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
    body['data']['records'].first(30).map{|x| x['videoLowURL']}
  end
end
