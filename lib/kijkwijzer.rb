require "kijkwijzer/version"
include ERB::Util
require 'nokogiri'
require 'open-uri'

module Kijkwijzer
  module ViewHelpers
    def render_kijkwijzer_svg_definitions
      svg_txt = File.open(open(File.join(Dir.pwd,'lib','kijkwijzer.svg'))).read
      svg_txt = svg_text.html_safe if defined?(ActiveSupport)
      svg_txt
    end
    def render_kijkwijzers result
      result_svgs = ""
      result.ratings.each do |rating|
        result_svgs+="<svg viewBox=\"0 0 100 100\" class=\"icon kijkwijzer rating kijkwijzer_#{rating}\"><use xlink:href=\"#kijkwijzer_base\"></use><use xlink:href=\"#kijkwijzer_#{rating}\"></use></svg>"
      end
      result_svgs
      result_svgs = result_svgs.html_safe if defined?(ActiveSupport)
      result_svgs
    end
  end

  class Result
    attr_accessor :title
    attr_accessor :production_type
    attr_accessor :year
    attr_accessor :ratings

    def ratings
      @ratings.collect do |rating|
        rating = rating.to_s.downcase
        rv = nil
        rv = rating if ["al","6","9","12","16"].include? rating
        rv = "violence" if ["violence","g"].include? rating
        rv = "scary" if ["scary","a"].include? rating
        rv = "sex" if ["sex","s"].include? rating
        rv = "drugs" if ["drugs","h"].include? rating
        rv = "discrimination" if ["discrimination","d"].include? rating
        rv = "language" if ["language","t"].include? rating
        rv
      end.compact
    end

    def to_s
      "#<Kijkwijzer::Result @title=\"#{title}\", @year=#{year}>"
    end
  end

  class << self
    def search_url(search)
      "http://www.kijkwijzer.nl/index.php?id=3__i&searchfor=#{url_encode(search)}&tab=KIJKWIJZER"
    end
    def get_content(search)
      Nokogiri::HTML(open(search_url(search)))
    end
    def search(search, filter={})
      res = get_content(search)
      results = []
      res.css('.content_hok .nieuwsitem').each do |result|
        r = Result.new()
        r.title = result.css('b').text
        meta_parse = result.text.match(/Productietype\:\s(.*)\.\sProductiejaar\:\s(\d\d\d\d)\.\s/)
        r.year = meta_parse[2].to_i
        r.production_type = meta_parse[1]
        r.ratings = result.css("img").collect{|a| a.attr("src").match(/\/images\/icons\/M_(.*)\.png/)[1]}
        include_r = true
        filter.each do |key, value|
          include_r = (r.send(key) == value)
        end
        results << r  if include_r
      end
      results
    end
  end
end
