require "nokogiri"
require "open-uri"

class TematresImporter

  URLS = {
    top_terms_url: "http://govt-urls.usa.gov/tematres/vocab/services.php?task=fetchTopTerms",
    nested_terms_url: "http://govt-urls.usa.gov/tematres/vocab/services.php?task=fetchDown&arg=%d",
    scope_notes_url: "http://govt-urls.usa.gov/tematres/vocab/services.php?task=fetchNotes&arg=%d",
    dates_url: "http://govt-urls.usa.gov/tematres/vocab/services.php?task=fetchTerm&arg=%d",
    alternates_url: "http://govt-urls.usa.gov/tematres/vocab/services.php?task=fetchAlt&arg=%d",
    related_terms_url: "http://govt-urls.usa.gov/tematres/vocab/services.php?task=fetchRelated&arg=%d"
  }

  def initialize(urls_hash = URLS)
    @top_terms_url = urls_hash[:top_terms_url]
    @nested_terms_url = urls_hash[:nested_terms_url]
    @scope_notes_url = urls_hash[:scope_notes_url]
    @dates_url = urls_hash[:dates_url]
    @alternates_url = urls_hash[:alternates_url]
    @related_terms_url = urls_hash[:related_terms_url]
  end

  def import
    top_level_terms = get_top_level_terms
    entries = get_nested_terms(top_level_terms)
    entries = merge_duplicates(entries)
    entries = process_fields(entries)
    entries = get_preferred_terms(entries)
 
    GovernmentUrl.index(entries)
  end

  def get_top_level_terms
    xml_doc = Nokogiri::XML(open(@top_terms_url))

    xml_doc.xpath('//term').map do |term|
      if !term.xpath('./code').text.start_with?('z ')
        { :id => term.xpath('./term_id').text,
          :name => term.xpath('./string').text }
      else
        nil
      end
    end.compact
  end

  def get_nested_terms(top_level_terms)
    entries = []
    top_level_terms.each do |parent|
      xml_doc = Nokogiri::XML(open(@nested_terms_url % parent[:id].to_i))
      new_entries = xml_doc.xpath('//term').map do |term|
        {
          id:   term.xpath('./term_id').text,
          name:   term.xpath('./string').text,
          parents:  [parent[:name]],
          scope_id: parse_scope_id(parent[:name])
        }
      end
      entries.concat(new_entries)
    end
    entries
  end

  def parse_scope_id(parent_name)
    if parent_name != "usagovFEDgov"
      scope_id = "usagov"
    else
      scope_id = parent_name
    end
    scope_id
  end

  def merge_duplicates(entries)
    new_entries = []
    entries.each do |entry|
      dup_entry_index = new_entries.index {|new_entry| new_entry[:id] == entry[:id] }
      if dup_entry_index.nil?
        new_entries.push(entry)
      else
        new_entries[dup_entry_index][:parents].concat(entry[:parents])
      end
    end
    new_entries
  end

  def process_fields(entries)
    entries.each do |entry|
      entry = get_scope_note(entry)
      entry = get_dates(entry)
      entry = parse_states_field(entry)
      entry = get_related_terms(entry)
      entry = get_non_preferred_terms(entry)
    end
    entries
  end

  def get_scope_note(entry)
    xml = Nokogiri::XML(open(@scope_notes_url % entry[:id].to_i))
    if !(xml.xpath('//term')[0].nil?)
      text = xml.xpath('//term')[0].xpath('./note_text').text
      clean_text = ActionView::Base.full_sanitizer.sanitize(text)
      entry.merge!({scope_note: clean_text })
    else
      entry.merge!({scope_note: ''})
    end
    entry
  end

  def get_dates(entry)
    xml = Nokogiri::XML(open(@dates_url % entry[:id].to_i))
    creation_date = Date.parse(xml.xpath('//term')[0].xpath('./date_create').text)
    last_modified_date = parse_last_modified_date(creation_date, xml.xpath('//term')[0].xpath('./date_mod').text)
    entry.merge!({
      creation_date: creation_date,
      last_modified_date: last_modified_date
    })
    entry
  end

  def parse_states_field(entry)
    entry[:states] = []
    entry[:parents].each do |parent|
      if parent =~ /\Ausagov[A-Z]{2}\z/
        state = parent.dup
        state.slice!("usagov")
        entry[:states].push(state)
      end
    end
    entry
  end

  def parse_last_modified_date(creation_date, last_modified_date_string)
    begin 
      Date.parse(last_modified_date_string)
    rescue ArgumentError
      creation_date
    end
  end

  def get_related_terms(entry)
    xml = Nokogiri::XML(open(@related_terms_url % entry[:id].to_i))
    related_terms = { related_terms: [], equivalent_related_terms: [] }
    if xml.xpath('//term').count > 0
      xml.xpath('//term').each do |term|
        if term.xpath('./relation_type').text == 'RT' && term.xpath('./relation_code').text == 'ET'
          related_terms[:equivalent_related_terms].push(term.xpath('./string').text)
        elsif term.xpath('./relation_type').text == 'RT'
          related_terms[:related_terms].push(term.xpath('./string').text)
        end
      end
    end
    entry.merge!(related_terms)
  end

  def get_non_preferred_terms(entry)
    xml = Nokogiri::XML(open(@alternates_url % entry[:id].to_i))
    alternate_terms = { preferred_terms: [], non_preferred_terms: [] }
    if xml.xpath('//term').count > 0
      xml.xpath('//term').each do |term|
        if term.xpath('./relation_type').text == 'UF'
          alternate_terms[:non_preferred_terms].push(term.xpath('./string').text)
        end
      end
    end
    entry.merge!(alternate_terms)
  end

  def get_preferred_terms(entries)
    entries.each do |entry|
      if entry[:non_preferred_terms].count > 0
        entry[:non_preferred_terms].each do |non_preferred_term|
          preferred_term_entry = entries.find{|e| e[:name] == non_preferred_term}
          preferred_term_entry[:preferred_terms].push(entry[:name]) if !preferred_term_entry.nil?
        end
      end
    end
    entries
  end

end