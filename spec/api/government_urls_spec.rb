require 'spec_helper'

describe 'Government Urls API', type: :request do

  before(:all) do
    fixtures_dir = "#{Rails.root}/spec/fixtures/government_urls"
    resource_hash = {
      top_terms_url: "#{fixtures_dir}/top_terms.xml",
      nested_terms_url: "#{fixtures_dir}/nested_terms/%d.xml",
      scope_notes_url: "#{fixtures_dir}/scope_notes/%d.xml",
      dates_url: "#{fixtures_dir}/dates/%d.xml",
      alternates_url: "#{fixtures_dir}/alternates/%d.xml",
      related_terms_url: "#{fixtures_dir}/related_terms/%d.xml"
    }
    GovernmentUrl.recreate_index
    TematresImporter.new(resource_hash).import
  end

  let(:search_path) { '/api/government_urls/search' }
  let(:expected_results) { YAML.load_file("#{Rails.root}/spec/fixtures/government_urls/search_results.yaml") }

  describe 'GET /api/government_urls/search.json' do

    context 'when search parameters are empty' do
      before { get search_path, { size: 50 } }
      subject { response }

      it 'returns govt url terms' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(3)
        results = json_response[:results]
        expect(results).to match_array expected_results
      end
    end

    context 'when q is specified' do
      let(:params) { { q: 'voa.gov' } }
      before { get search_path, params}
      subject { response }

      it 'returns gotentries' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(2)

        results = json_response[:results]
        expect(results[0]).to eq(expected_results[0])
        expect(results[1]).to eq(expected_results[1])
      end
    end

    context 'when states are specified' do
      let(:params) { { states: 'fl' } }
      before { get search_path, params}
      subject { response }

      it 'returns gotentries' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(1)

        results = json_response[:results]
        expect(results[0]).to eq(expected_results[2])
      end
    end

    context 'when scope_ids are specified' do
      let(:params) { { scope_ids: 'usagov' } }
      before { get search_path, params}
      subject { response }

      it 'returns gotentries' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(2)

        results = json_response[:results]
        expect(results[0]).to eq(expected_results[0])
        expect(results[1]).to eq(expected_results[2])
      end
    end

  end
end
