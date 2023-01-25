# frozen_string_literal: true

require './block'
require './blockchain'

RSpec.describe Blockchain do
  subject(:blockchain) { described_class.new }

  it 'contains a `chain` Array instance' do
    expect(subject.chain).to be_a(Array)
  end

  it 'starts with a genesis block' do
    expect(subject.chain.first.to_h).to eql(Block.genesis.to_h)
  end

  it 'adds a new block to the chain' do
    new_data = 'foobar'
    subject.add_block({data: new_data})

    expect(subject.chain.last.data).to eql(new_data)
  end

  describe '#valid_chain?' do
    context 'when the chain starts with a genesis block and has multiple blocks' do
      before do
        subject.add_block({ data: 'Bears' })
        subject.add_block({ data: 'Beets' })
        subject.add_block({ data: 'Battlestar Galactica' })
      end

      context 'and a last_hash reference has changed' do
        it 'returns false' do
          subject.chain[2].last_hash = 'broken-last-hash'

          expect(described_class.valid_chain?(subject.chain)).to be_falsey
        end
      end

      context 'and the chain contains a block with an invalid field' do
        it 'returns false' do
          subject.chain[2].data = 'invalid_data'

          expect(described_class.valid_chain?(subject.chain)).to be_falsey
        end
      end

      context 'and the chain does not contain any invalid blocks' do
        it 'returns true' do
          expect(described_class.valid_chain?(subject.chain)).to be_truthy
        end
      end
    end
  end
end
