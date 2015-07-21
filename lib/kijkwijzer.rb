require "kijkwijzer/version"
include ERB::Util
require 'nokogiri'
require 'open-uri'
require 'kijkwijzer/result'
require 'kijkwijzer/railtie' if defined?(Rails)

module Kijkwijzer
  class << self
    def search_url(search)
      "http://www.kijkwijzer.nl/index.php?id=3__i&searchfor=#{url_encode(search)}&tab=KIJKWIJZER"
    end
    def get_content(search)
      Nokogiri::HTML(open(search_url(search)))
    end

    # Search the Kijkwijzer database
    #
    # @return [Kijkwijzer::Result]
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
