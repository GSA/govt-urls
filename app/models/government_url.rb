class GovernmentUrl
	extend Indexable

  self.mappings = {
    government_url: {
      _timestamp: {
        enabled: true,
        store:   true,
      },
      dynamic:    'true',
      properties: {
        name:     { type: 'string' },
        parents:     { type: 'string' },
        states:     { type: 'string', index: "not_analyzed" },
        creation_date: { type: 'date' },
        last_modified_date: { type: 'date' },
        scope_note: { type: 'string' },
        scope_id: { type: 'string', index: "not_analyzed" },
        related_terms: { type: 'string' },
        equivalent_related_terms: { type: 'string' },
        non_preferred_terms: { type: 'string' },
        preferred_terms: { type: 'string' },
      },
    },
  }.freeze

end