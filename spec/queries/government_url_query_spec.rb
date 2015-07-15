require 'spec_helper'

describe GovernmentUrlQuery do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/government_urls/queries" }

  describe '#generate_search_body' do

    context 'when options is an empty hash' do
      let(:query) { GovernmentUrlQuery.new({}) }

      it 'generates search body with default options' do
        expect(JSON.parse(query.generate_search_body)).to eq({})
      end
    end

    context 'when options include q' do
      let(:query) { GovernmentUrlQuery.new(q: 'voa.gov') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/match_q.json").read }

      it 'generates search body with queries' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include states' do
      let(:query) { GovernmentUrlQuery.new(states: 'va,ga') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/filter_states.json").read }

      it 'generates search body with queries' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include scope_ids' do
      let(:query) { GovernmentUrlQuery.new(scope_ids: 'usagovFEDgov') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/filter_scope_ids.json").read }

      it 'generates search body with queries' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

  end
end
