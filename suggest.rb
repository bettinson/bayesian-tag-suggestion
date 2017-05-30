require_relative 'lib/link_trainer.rb'
require_relative 'lib/link.rb'

keyfile = File.open('./data/training_links.txt', 'rb')
lt = LinkTrainer.new(keyfile)



guess_link = Link.new("https://www.stackoverflow.com", [])
guess_links = Array.new
guess_links << guess_link

guess_links.each do |l|
  classification = lt.classify(l)
  puts "#{l.url} is #{classification.guess} with #{classification.score.to_s} accuracy"
end
