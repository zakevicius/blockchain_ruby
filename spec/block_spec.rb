# frozen_string_literal: true

require 'rspec'
require './config/config'
require './block'
require './crypto_hash'

RSpec.describe Block do
  let(:timestamp) { 'a-date' }
  let(:last_hash) { 'foo-hash' }
  let(:hash) { 'bar_hash' }
  let(:data) { %w[blockchain data] }
  let(:block) { Block.new({ timestamp: timestamp, last_hash: last_hash, hash: hash, data: data }) }

  it 'has a `timestamp`, `last_hash`, `hash` and `data` properties' do
    expect(block.timestamp).to eq(timestamp)
    expect(block.last_hash).to eq(last_hash)
    expect(block.hash).to eq(hash)
    expect(block.data).to eq(data)
  end

  describe '#genesis' do
    let(:genesis_block) { Block.genesis }

    it 'returns a Block instance' do
      expect(genesis_block).to be_a(described_class)
    end

    it 'returns the genesis data' do
      expect(genesis_block.to_h).to eql(Config::GENESIS_DATA)
    end
  end

  describe '#mine_block' do
    let(:last_block) { described_class.genesis }
    let(:data) { 'miner data' }
    let(:mined_block) { described_class.mine_block({ last_block: last_block, data: data }) }

    it 'returns a block instance' do
      expect(mined_block).to be_a(described_class)
    end

    it 'sets the `last_hash` to be a `hash` of the last_block' do
      expect(mined_block.last_hash).to eql(last_block.hash)
    end

    it 'sets the `data`' do
      expect(mined_block.data).to eql(data)
    end

    it 'sets a `timestamp`' do
      expect(mined_block.timestamp).not_to be_nil
    end

    it 'creates a SHA256 hash based on proper inputs' do
      expect(mined_block.hash).to eql(CryptoHash.new(mined_block.timestamp, last_block.hash, data).hex_digest)
    end
  end
end
