# frozen_string_literal: true

module Config
  INITIAL_DIFFICULTY = 3
  MINE_RATE = 1000

  GENESIS_DATA = {
    timestamp: 1,
    last_hash: '-----',
    hash: 'hash-one',
    data: [],
    difficulty: INITIAL_DIFFICULTY,
    nonce: 0
  }.freeze
end
