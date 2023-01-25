# frozen_string_literal: true
require 'json'
require './block'
require './crypto_hash'

class Blockchain
  attr_reader :chain
  def initialize
    @chain = [Block.genesis]
  end

  def add_block(options)
    new_block = Block.mine_block({
                                   last_block: @chain.last,
                                   data: options[:data]
                                 })

    @chain << new_block
  end

  class << self
    def valid_chain?(chain)
      return false unless JSON.generate(chain.first.to_h) == JSON.generate(Block.genesis.to_h)

      chain[1..].each.with_index(1) do|block, i|
        block.to_h => {timestamp:, last_hash:, hash:, data:, nonce:, difficulty: }

        actual_last_hash = chain[i - 1].hash

        return false unless actual_last_hash == last_hash

        validated_hash = CryptoHash.new(timestamp, last_hash, data, nonce, difficulty).hex_digest

        return false unless hash == validated_hash
      end
    end
  end
end
