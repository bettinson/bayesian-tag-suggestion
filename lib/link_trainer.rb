require 'set'
require_relative 'link.rb'

class LinkTrainer
  Classification = Struct.new(:guess, :score)
  attr_accessor :to_train
  attr_reader :totals, :categories

  def initialize(training_files)
    setup!(training_files)
  end

  def setup!(training_files)
    @tags = Set.new

    training_files.each do |tf|
      @tags << tf.split(/#|https?:\/\//).map(&:split).first
    end

    @totals = Hash[@tags.map{ |t|
      [t, 0]
    }]
    @totals.default = 0
    @totals['_all'] = 0

    @training = Hash[@tags.map { |t| [t, Hash.new(0)]}]
  end

  def total_for(tag)
    @totals.fetch(tag)
  end

  def write(tag, url)
    if url.nil?
      return
    end
    link = Link.new(url)

    @tags << tag
    @training[tag] || Hash.new(0)

    # Tokenizes a URL into pieces
    # EG: codinghorror.com -> coding horror
    # Not the best approach but it works for now
    # Not implemented

    Tokenizer.tokenize(url) do |token|
      @training[tag][token] += 1
      @totals['_all'] += 1
      @totals[tag] += 1
    end
  end
end
