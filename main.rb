# ライブラリ
require 'sinatra'

# 開発環境用ライブラリ
if settings.development?
  require 'pry'
  require 'sinatra/reloader'
end

# クラス
require './class/vine.rb'
require './class/itunes.rb'
require './class/extract.rb'

get '/' do
  erb :index
end

# 音楽の検索
get '/music' do
  info = params["info"]
  search = Itunes.new()
  @music = search.search_musics(info)
  content_type :json
  data = { music: @music }
  data.to_json
end

# 検索ワードの決定
get '/fixed' do
  tag_pick = Extract.new()
  t = tag_pick.pickup_words(params["track"])
  @tags = t.compact
  content_type :json
  data = { artist: params["artist"],  track: params["track"], id: params["id"], tags: @tags}
  data.to_json
end

# 映像の出力
post '/result' do
  @bpm = params["bpm"]
  t = params["tags"]
  id = params["id"]

  music = Itunes.new()
  @music_url = music.search_music_by_id(id)

  t = t.gsub(" ", "")

  tags = []
  if t.index(",")
    tags = t.split(",")
  else
    tags << t
  end

  video = Vine.new()
  v = tags.map { |tag| video.search_tag(tag) }

  v.flatten!
  v = v.compact
  v.sort!
  v = v + v + v + v
  @videos = v[0, 40]

  erb :result
end

# リロードしたらトップへ
get '/result' do
  redirect '/'
end
