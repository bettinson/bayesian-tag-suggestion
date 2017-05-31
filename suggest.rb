require_relative 'lib/link_trainer.rb'
require_relative 'lib/link.rb'
require "test/unit"



class TestTokenizer < Test::Unit::TestCase
  def test_blackbox
    keyfile = File.open('./data/training_links.txt', 'rb')
    lt = LinkTrainer.new(keyfile)

    guess_link = Link.new("https://www.codinghorror.com", [])
    guess_links = Array.new
    guess_links << guess_link

    guess_links.each do |l|
      classification = lt.classify(l)
      puts "#{l.url} is #{classification.guess} with #{classification.score.to_s} accuracy"
      guess = classification.guess.dup.to_s.encode!('UTF-8', 'UTF-8', :invalid => :replace)

      assert_equal(guess, "blog")
    end
  end
end
