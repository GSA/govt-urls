require 'rails_helper'

describe TematresImporter do
  before { GovernmentUrl.recreate_index }

  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/government_urls/" }
  let(:resource) do
    {
      top_terms_url: "#{fixtures_dir}/top_terms.xml",
      nested_terms_url: "#{fixtures_dir}/nested_terms/%d.xml",
      scope_notes_url: "#{fixtures_dir}/scope_notes/%d.xml",
      dates_url: "#{fixtures_dir}/dates/%d.xml",
      alternates_url: "#{fixtures_dir}/alternates/%d.xml",
      related_terms_url: "#{fixtures_dir}/related_terms/%d.xml"
    }
  end

  let(:importer) { TematresImporter.new(resource) }

  describe '#import_and_if_possible_purge_old' do
    let(:entry_hash) { YAML.load_file("#{fixtures_dir}/results.yaml") }

    it 'loads government url terms from specified resource' do
      expect(GovernmentUrl).to receive(:index) do |entries|
        expect(entries.size).to eq(3)
        expect(entries).to match_array entry_hash
      end
      importer.import_and_if_possible_purge_old
    end
  end

end
