json.call(@search, :total, :offset)
json.results do
  json.array! @search[:hits] do |hit|
    entry = hit.deep_symbolize_keys
    json.id entry[:_id]
    json.call(entry[:_source],
          :name, :parents, :states, :creation_date, :last_modified_date, :scope_note, :scope_id,
          :related_terms, :equivalent_related_terms, :non_preferred_terms, :preferred_terms
    )
  end
end
