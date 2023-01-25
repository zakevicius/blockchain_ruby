# frozen_string_literal
require 'date'

class Block
  include Config

  attr_reader :timestamp, :last_hash, :hash, :data

  def initialize(options)
    @timestamp = options[:timestamp]
    @last_hash = options[:last_hash]
    @hash = options[:hash]
    @data = options[:data]
  end

  class << self
    def genesis
      new(Config::GENESIS_DATA)
    end

    def mine_block(options)
      timestamp = Time.now.to_i.to_s
      last_hash = options[:last_block].hash

      new({
            timestamp: timestamp,
            last_hash: last_hash,
            data: options[:data],
            hash: CryptoHash.new(timestamp, last_hash, options[:data]).hex_digest
          })
    end
  end

  def to_h
    Hash[instance_variables.map { |key| [key[1..].to_sym, instance_variable_get(key)] }]
  end
end
