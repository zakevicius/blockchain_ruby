# frozen_string_literal: true
require 'digest'

class CryptoHash
  attr_reader :hex_digest

  def initialize(*args)
    @hex_digest = Digest::SHA2.new(256).hexdigest [*args].sort.join(' ')
  end
end
