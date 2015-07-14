class GovernmentUrlQuery

  DEFAULT_SIZE = 10.freeze
  MAX_SIZE = 100.freeze
  attr_reader :offset, :size, :sort, :q

  def initialize(options = {})
    options.reverse_merge!(size: DEFAULT_SIZE)

    cleanup_invalid_bytes(options, [:q])

    @offset = options[:offset].to_i
    @size   = [options[:size].to_i, MAX_SIZE].min
    @q      = options[:q].downcase if options[:q].present?
    @states = options[:states].upcase.split(',') if options[:states].present?
    @scope_ids = options[:scope_ids].split(',') if options[:scope_ids].present?
  
  end

  def generate_search_body
    Jbuilder.encode do |json|
      generate_query(json)
      generate_filter(json)
    end
  end

  def generate_filter(json)
    json.filter do
      json.bool do
        json.must do
          json.child! { json.terms { json.states @states } } if @states
          json.child! { json.terms { json.scope_id @scope_ids } } if @scope_ids
        end
      end
    end if @states || @scope_ids
  end

  def generate_query(json)
    json.query do
      json.bool do
        json.must do
          json.child! do
            generate_multi_match(json, %w(name parents scope_note related_terms 
              equivalent_related_terms non_preferred_terms preferred_terms), @q)
          end if @q
        end
      end
    end if @q
  end

  def generate_multi_match(json, fields, query, operator = :and)
    json.multi_match do
      json.fields fields
      json.operator operator
      json.query query
    end if query
  end
  private

  def cleanup_invalid_bytes(obj, fields)
    fields.each do | f |
      obj[f] = obj[f].encode('UTF-8', 'UTF-8', invalid: :replace, undef: :replace, replace: '') if obj[f]
    end
  end

end
