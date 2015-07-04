require 'faraday'
require 'faraday_middleware'
require 'json'
require 'uri'

class Vine
  def initialize
    @client = Faraday.new(:url => "https://api.vineapp.com/")
  end

  def search_tag(t)
    tag = URI.escape(t)
    posts = @client.get "timelines/tags/#{tag}"
    body = JSON.parse posts.body
    urls = []
    body['data']['records'].each_with_index do |record, i|
      break if i + 1 == 30
      urls << record['videoLowURL']
    end
    urls
  end
end
