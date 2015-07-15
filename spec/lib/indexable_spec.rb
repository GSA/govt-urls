require 'spec_helper'

shared_context 'a working Mock model class' do
  before do
    class Mock
      extend Indexable
      self.mappings = {
        mock: {
          _timestamp: {
            enabled: true,
            store:   true,
          },
        },
      }
    end
  end
end

describe Indexable do
  after { Object.send(:remove_const, :Mock) }

  describe '.prepare_record_for_indexing' do
    context 'given a record with ttl and timestamp settings' do
      include_context 'a working Mock model class'
      let(:now) { Time.now.to_i * 1000 }
      let(:record) do
        { ttl:       '1d',
          timestamp: now,
          field1:       'value1',
          field2:       'value2',
          id:        1337 }
      end
      subject { Mock.send(:prepare_record_for_indexing, record) }

      it do
        is_expected.to eq(body:      { field1: 'value1', field2: 'value2' },
                          id:        1337,
                          index:     'test:mock',
                          timestamp: now,
                          ttl:       '1d',
                          type:      :mock)
      end
    end
  end

  describe '.can_purge_old?' do
    context 'with a model that has a _timestamp mapping' do
      include_context 'a working Mock model class'
      subject { Mock.can_purge_old? }
      it { is_expected.to be_truthy }
    end

    context 'with a model that does not have a _timestamp mapping' do
      before do
        class Mock
          extend Indexable
          self.mappings = { mock: {} }
        end
      end
      subject { Mock.can_purge_old? }
      it { is_expected.to be_falsey }
    end
  end

  describe '.purge_old' do
    include_context 'a working Mock model class'
    before do
      Mock.recreate_index
      Mock.index(docs_to_index)
    end

    let(:docs_to_index) do
      [{ title: 'foo', timestamp: 2.days.ago.to_i * 1000 },
       { title: 'bar' }]
    end
    let(:docs_expected) do
      [{ 'title' => 'foo' },
       { 'title' => 'bar' }]
    end

    let(:search) { ES.client.search(index: Mock.index_name) }

    subject(:total) { search['hits']['total'] }
    subject(:docs_retrieved) do
      search['hits']['hits'].map { |h| h['_source'] }
    end

    context 'with date arg earlier than oldest doc' do
      before { Mock.purge_old(3.days.ago) }
      it 'does not purge any documents' do
        expect(total).to eq 2
        expect(docs_retrieved).to match_array(docs_expected)
      end
    end

    context "with date arg between the two docs' timestamps" do
      before { Mock.purge_old(1.day.ago) }
      it 'purges only the oldest doc' do
        expect(total).to eq 1
        expect(docs_retrieved).to eq([docs_expected[1]])
      end
    end

    context 'with date arg later than newest doc' do
      before { Mock.purge_old(Time.now) }
      it 'purges all documents' do
        expect(total).to eq 0
        expect(docs_retrieved).to eq([])
      end
    end
  end

end
