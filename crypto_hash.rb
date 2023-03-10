# frozen_string_literal: true
require 'digest'

class CryptoHash
  attr_reader :hex_digest

  def initialize(*args)
    @hex_digest = Digest::SHA256.hexdigest [*args].map(&:to_s).sort.join(' ')
  end
end
