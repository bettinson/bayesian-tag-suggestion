require 'uri'

module Tokenizer
  extend self

  # Tokenizes a URL into pieces
  # EG: codinghorror.com -> coding horror
  # Not the best approach but it works for now
  def tokenize(line, &block)
    u = URI.parse("http://www.#{line}")
    return u.host
  end
end
