# frozen_string_literal: true
require './crypto_hash'

RSpec.describe CryptoHash do
  it 'generates a SHA-256 hashed output' do
    expect(described_class.new('foo').hex_digest).to eql('2c26b46b68ffc68ff99b453c1d30413413422d706483bfa0f98a5e886266e7ae')
  end

  it 'produces the same hash with the same input arguments in any order' do
    expect(described_class.new('one', 'two', 'three').hex_digest).to eql(described_class.new('three', 'one', 'two').hex_digest)
  end
end
