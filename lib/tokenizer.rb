require 'uri'

module Tokenizer
  extend self

  # Tokenizes should put URL into pieces
  # EG: codinghorror.com -> coding horror
  # Not the best approach but it works for now
  def tokenize(line, &block)
    u = URI.parse("#{line}")
    return u.host
  end
end
