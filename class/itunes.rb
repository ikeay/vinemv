require 'faraday'
require 'faraday_middleware'
require 'json'

class Itunes

  # 初期化
  def initialize
    @client = Faraday.new(:url => "https://itunes.apple.com/")
    @clientLookup = Faraday.new(:url => "https://itunes.apple.com/")
  end

  def search_by_tag(tag, limit)
    response = @client.get do |req|
      req.url '/search', :term => tag
      req.params['limit'] = limit
      req.params['country'] = "jp"
    end
    JSON.parse response.body
  end

  # タグからアーティストを検索
  def search_artist(tag)
    body = search_by_tag(tag, 50)
    body['results'][0]['previewUrl']
  end

  # タグから音楽を検索
  def search_musics(tag)
    body = search_by_tag(tag, 30)
    artist_name = []
    track_name = []
    track_id = []
    body['results'].each do |result|
        artist_name << result['artistName']
        track_name <<  result['trackName']
        track_id << result['trackId']
    end
    {artist: artist_name, track: track_name, id: track_id}
  end

 # 曲をトラックIDから検索
  def search_music_by_id(id)
    response = @clientLookup.get do |req|
      req.url '/lookup', :id => id
      req.params['country'] = "jp"
    end
    body = JSON.parse response.body
    body['results'][0]['previewUrl']
  end
end
