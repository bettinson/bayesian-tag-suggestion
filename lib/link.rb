class Link
  attr_reader :tags

  def initialize(url, tags = [])
    @url = url
    @tags = tags
  end

  def url
    @url.to_s.force_encoding('UTF-8')
  end
end
