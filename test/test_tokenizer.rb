require "test/unit"
require_relative '../lib/link_trainer.rb'
require_relative '../lib/link.rb'
require_relative '../lib/tokenizer.rb'

class TestTokenizer < Test::Unit::TestCase

  def test_simple

    assert_equal("codinghorror.com", Tokenizer.tokenize("http://codinghorror.com"))
  end

end
