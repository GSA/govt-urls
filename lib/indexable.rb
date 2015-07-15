module Indexable
  attr_accessor :mappings, :settings
  attr_writer :index_name, :index_type

  def index_name
    assign_index_name unless defined?(@index_name)
    @index_name
  end

  def index_type
    assign_index_type unless defined?(@index_type)
    @index_type
  end

  def assign_index_name
    self.index_name = [ES::INDEX_PREFIX, name.underscore].join(':').freeze
  end

  def assign_index_type
    self.index_type = name.underscore.to_sym.freeze
  end

  def create_index
    ES.client.indices.create(
        index: index_name,
        body:  { settings: settings, mappings: mappings })
  end

  def recreate_index
    delete_index if index_exists?
    create_index
  end

  def delete_index
    ES.client.indices.delete index: index_name
  end

  def index_exists?
    ES.client.indices.exists index: index_name
  end

  def index(records)
    records.each { |record| ES.client.index(prepare_record_for_indexing(record)) }
    ES.client.indices.refresh(index: index_name)

    Rails.logger.info "Imported #{records.size} entries to index #{index_name}"
  end

  def prepare_record_for_indexing(record)
    prepared = {
      index: index_name,
      type:  index_type,
      id:    record[:id],
      body:  record.except(:id, :ttl, :timestamp),
    }
    prepared.merge!(ttl: record[:ttl]) if record[:ttl]
    prepared.merge!(timestamp: record[:timestamp]) if record[:timestamp]
    prepared
  end

  def search_for(options)
    klass = "#{name}Query".constantize rescue "#{name}Query".constantize
    query = klass.new(options)
    hits = ES.client.search(
      index: index_name,
      type:  index_type,
      body:  query.generate_search_body,
      from:  query.offset,
      size:  query.size,
      sort:  query.sort)['hits'].deep_symbolize_keys
    hits[:offset] = query.offset
    hits.deep_symbolize_keys
  end

  def purge_old(before_time)
    fail 'This model is unable to purge old documents' unless can_purge_old?
    body = {
      query: {
        filtered: {
          filter: {
            range: {
              _timestamp: {
                lt: (before_time.to_f * 1000.0).to_i,
              },
            },
          },
        },
      },
    }

    ES.client.delete_by_query(index: index_name, body: body)
  end

  def can_purge_old?
    timestamp_field = mappings[name.underscore.to_sym][:_timestamp]
    timestamp_field && timestamp_field[:enabled] && timestamp_field[:store]
  end

end