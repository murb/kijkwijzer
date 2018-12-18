require "kijkwijzer/version"
include ERB::Util
require 'nokogiri'
require 'open-uri'
require 'kijkwijzer/result'
require 'kijkwijzer/railtie' if defined?(Rails)

module Kijkwijzer
  POSSIBLE_RATINGS = [
    {name: "Alle leeftijden", value: "al", code: "al"},
    {name: "6 jaar en ouder", value: "6", code: "6"},
    {name: "9 jaar en ouder", value: "9", code: "9"},
    {name: "12 jaar en ouder", value: "12", code: "12"},
    {name: "16 jaar en ouder", value: "16", code: "16"},
    {name: "Geweld", value: "violence", code: "g"},
    {name: "Angst", value: "scary", code: "a"},
    {name: "Seks", value: "sex", code: "s"},
    {name: "Discriminatie", value: "discrimination", code: "d"},
    {name: "Drugs en/of alcoholmisbruik", value: "drugs", code: "h"},
    {name: "Grof taalgebruik", value: "language", code: "t"}
  ]
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
        production_type_match = result.text.match(/Productietype\:\s(.*)\.(\sProductie)/)
        production_year_match = result.text.match(/\sProductiejaar\:\s(\d\d\d\d)\.\s/)
        r.year = production_year_match[1].to_i if production_year_match
        r.production_type = production_type_match[1] if production_type_match
        r.ratings = result.css("img").collect{|a| a.attr("src").match(/\/upload\/pictogrammen\/\d*_\d*_(.*)\.png/)[1]}
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
