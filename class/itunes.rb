require 'faraday'
require 'faraday_middleware'
require 'json'

class Itunes

  # 初期化
  def initialize
    @client = Faraday.new(:url => "https://itunes.apple.com/")
    @clientLookup = Faraday.new(:url => "https://itunes.apple.com/")
  end

  # タグからアーティストを検索
  def search_artist(tag)
    posts = @client.get "/search?term=#{tag}&limit=50&country=jp"
    body = JSON.parse posts.body
    url = body['results'][0]['previewUrl']
  end

  # タグから音楽を検索
  def search_musics(tag)
    posts = @client.get "/search?term=#{tag}&limit=30&country=jp"
    body = JSON.parse posts.body
    artist_name = []
    track_name = []
    track_id = []
    body['results'].each do |result|
        artist_name << result['artistName']
        track_name <<  result['trackName']
        track_id << result['trackId']
    end
    results = {artist: artist_name, track: track_name, id: track_id}
  end

 # 曲をトラックIDから検索
  def search_music_for_id(id)
    posts = @clientLookup.get "/lookup?id=#{id}&country=jp"
    body = JSON.parse posts.body
    url = body['results'][0]['previewUrl']
  end
end