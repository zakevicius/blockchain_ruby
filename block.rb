# frozen_string_literal
require 'date'
require './config/config'

class Block
  attr_accessor :timestamp, :last_hash, :hash, :data, :nonce, :difficulty

  def initialize(options)
    @timestamp = options[:timestamp]
    @last_hash = options[:last_hash]
    @hash = options[:hash]
    @data = options[:data]
    @nonce = options[:nonce]
    @difficulty = options[:difficulty]
  end

  class << self
    def genesis
      new(Config::GENESIS_DATA)
    end

    def mine_block(options)
      last_hash = options[:last_block].hash
      difficulty = options[:last_block].difficulty
      nonce = 0

      begin
      nonce += 1
      timestamp = Time.now.to_i
      hash = CryptoHash.new(timestamp, last_hash, options[:data], nonce, difficulty).hex_digest
      difficulty = adjust_difficulty({
                                       original_block: options[:last_block],
                                       timestamp: timestamp
                                     })
      end while hash[...difficulty] != '0' * difficulty

      new({
            timestamp: timestamp,
            last_hash: last_hash,
            data: options[:data],
            hash: hash,
            nonce: nonce,
            difficulty: difficulty
          })
    end

    def adjust_difficulty(options)
      difficulty = options[:original_block].difficulty

      return 1 if difficulty < 1

      options[:timestamp] - options[:original_block].timestamp > Config::MINE_RATE ? difficulty - 1 : difficulty + 1
    end
  end

  def to_h
    Hash[instance_variables.map { |key| [key[1..].to_sym, instance_variable_get(key)] }]
  end
end
