require 'set'
require_relative 'link.rb'
require_relative 'tokenizer.rb'
require 'byebug'

class LinkTrainer
  Classification = Struct.new(:guess, :score)
  attr_accessor :to_train
  attr_reader :totals, :categories

  def initialize(training_file)
    setup!(training_file)
  end

  # training_file is an array of tags and url strings
  # this gets all the different tags
  def setup!(training_file)
    @tags = Set.new
    @to_train = Array.new
    @keywords_for_tag = Hash.new { |h, k| h[k] = Set.new }

    # Splits each line into the tags
    training_file.each_line do |tf|
      tags = tf.split(/#|https?:\/\//).map(&:split).first
      url = tf.split(/#|https?:\/\//).map(&:split).last.to_s.tr('["', '').tr('"]', '')

      link = Link.new(url, tags)
      @to_train << link

      tags.each do |t|
        @tags << t
      end
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

  # Iterates over the @to_train array and writes it to training data
  def train!
    @to_train.each do |link|
      write(link)
    end

    @to_train = []
  end

  # Writes the link to training data
  def write(link)
    tags = link.tags
    url = link.url

    if url.nil?
      return
    end

    # Tokenizes a URL into pieces
    # EG: codinghorror.com -> coding horror
    # Not the best approach but it works for now
    # Not implemented, just puts a URL right now
    token = Tokenizer.tokenize("http://#{url}")

    throw 'error' if token.nil?

    tags.each do |tag|
      @training[tag][token] += 1
      @totals['_all'] += 1
      # Add the token(s) to the tag
      @keywords_for_tag[tag] << token
    end
  end

  # This is a micro-score for the tag and token/keyword
  def get(tag, token)
    @training[tag][token].to_i
  end

  # How many keyword for each tag
  def total
    sum = 0
    @keywords_for_tag.each_key {|key|
      sum += @keywords_for_tag[key].count
    }
    sum
  end

  # Score for a link based on existing training data
  # Different strategies could include similiar sequential characters in a link
  # or substrings that overlap
  def score(link)
    train!
    url = link.url
    tag_totals = @totals

    # aggregates is a hash with key t and value of the ratio between how many keywords
    # the tag has and the total amount of keywords and tags. This is the normalized
    # Bayesian score

    aggregates = Hash[@tags.map do |t|
      [
        t,
        Rational(@keywords_for_tag[t].count, total)
      ]
    end]

    token = Tokenizer.tokenize(url)

    aggregates
  end

  # Sorted tags based on values
  def preference
    @tags.sort_by {|t| total_for(t)}
  end

  # Uses the score to classify a link into its most likely tag
  def classify(link)
    score = score(link)
    p score
    max_score = 0.0
    max_key = preference.last

    # Finds the tag with the largest value of match
    score.each do |k, v|
      if v > max_score
        max_key = k
        max_score = v
      elsif v == max_score && preference.index(k) < preference.index(max_key)
        max_key = k
        max_score = v
      else
      end
    end
    throw 'error' if max_key.nil?
    Classification.new(max_key, max_score)
  end
end
