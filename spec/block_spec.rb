# frozen_string_literal: true

require 'rspec'
require './config/config'
require './block'
require './crypto_hash'

RSpec.describe Block do
  let(:timestamp) { 1674659416742 }
  let(:last_hash) { 'foo-hash' }
  let(:hash) { 'bar_hash' }
  let(:data) { %w[blockchain data] }
  let(:nonce) { 1 }
  let(:difficulty) { 1 }
  let(:block) { Block.new({
                            timestamp: timestamp,
                            last_hash: last_hash,
                            hash: hash,
                            data: data,
                            nonce: nonce,
                            difficulty: difficulty
                          })}

  it 'has a `timestamp`, `last_hash`, `hash`, `data`, `nonce` and `difficulty` properties' do
    expect(block.timestamp).to eq(timestamp)
    expect(block.last_hash).to eq(last_hash)
    expect(block.hash).to eq(hash)
    expect(block.data).to eq(data)
    expect(block.nonce).to eq(nonce)
    expect(block.difficulty).to eq(difficulty)
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

    it 'creates a SHA256 hash based on proper inputs'do
      expect(mined_block.hash).to eql(CryptoHash.new(
        mined_block.timestamp,
        mined_block.difficulty,
        mined_block.nonce,
        last_block.hash,
        data
      ).hex_digest)
    end

    it 'sets the `hash` that matched the difficulty criteria' do
      expect(mined_block.hash[...mined_block.difficulty]).to eq('0' * mined_block.difficulty)
    end

    it 'adjusts the difficulty' do
      possible_results = [last_block.difficulty + 1, last_block.difficulty - 1]

      expect(possible_results).to include(mined_block.difficulty)
    end
  end

  describe '#adjust_difficulty' do
    it 'raises the difficulty for a quickly mined block' do
      expect(described_class.adjust_difficulty({ original_block: block, timestamp: block.timestamp + Config::MINE_RATE + 100})).to eq(block.difficulty - 1)
    end

    it 'raises the difficulty for a slowly mined block' do
      expect(described_class.adjust_difficulty({ original_block: block, timestamp: block.timestamp + Config::MINE_RATE - 100})).to eq(block.difficulty + 1)
    end

    it 'has a lower limit of 1' do
      block.difficulty = -1

      expect(described_class.adjust_difficulty({ original_block: block })).to eq(1)
    end
  end
end
