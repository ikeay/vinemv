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
    url = []
    30.times do |i|
      if !body['data']['records'][i].nil?
        url << body['data']['records'][i]['videoLowURL']
      end
    end
    url
  end
end