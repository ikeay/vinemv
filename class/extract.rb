require 'bing_translator'
require 'natto'
require 'engtagger'

YOUR_CLIENT_ID = ENV["YOUR_CLIENT_ID"]
YOUR_CLIENT_SECRET = ENV["YOUR_CLIENT_SECRET"]
AZURE_ACCOUNT_KEY = ENV["AZURE_ACCOUNT_KEY"]

class Extract
  def initialize
    @natto = Natto::MeCab.new
    @translator = BingTranslator.new(YOUR_CLIENT_ID, YOUR_CLIENT_SECRET, false, AZURE_ACCOUNT_KEY)
  end

  # 日本語を含んでいるか
  def has_mb?(str)
    str.bytes do |b|
      return true if  (b & 0b10000000) != 0
    end
    false
  end

  # 日本語に訳す
  def translate_ja(text)
    japanese = @translator.translate(text, :from => 'en', :to => 'ja')
  end

  # 英語の題名
  def pickup_en(text)
    tgr = EngTagger.new
    tagged = tgr.add_tags(text)
    word_list = tgr.get_words(text)
    nouns = tgr.get_nouns(tagged)
    nouns_array = nouns.keys
    nouns_array_downcase = []
    jwords = []
    for i in 0..nouns_array.length-1 do
      jwords << translate_ja(nouns_array[i].downcase)
      nouns_array_downcase << nouns_array[i].downcase
    end
    nouns_array_downcase = nouns_array_downcase + jwords
  end

  # 日本語の題名
  def pickup_ja(text)
    words = []
    jwords = []
    # 英語のタグと日本語のタグを生成する
    # 日本語タグの中にもし英語が混ざっていたら日本語に翻訳処理する
    @natto.parse(text) do |n|
      prop = n.feature.split(",")
      if prop[0] =~ /^名詞/ then
        #　もし英語が混ざっていたら日本語訳処理する
        if n.surface.to_s.ascii_only?
          jwords << translate_ja(n.surface.to_s)
        else
          jwords << n.surface.to_s
        end
        japanese = @translator.translate(n.surface.to_s, :from => 'ja', :to => 'en')
        words << japanese.downcase!
      end
    end
    words = words + jwords # タグに日本語も追加
  end

  def pickup_words(text)
    if has_mb?(text) # 日本語
      pickup_ja(text)
    else # 英語
      pickup_en(text)
    end
  end

end
