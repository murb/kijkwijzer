require "kijkwijzer/version"
include ERB::Util
require 'nokogiri'
require 'open-uri'
require 'kijkwijzer/result'
require 'kijkwijzer/railtie' if defined?(Rails)

module Kijkwijzer
  POSSIBLE_RATINGS = [
    {nl_key: "alle-leeftijden", name: "Alle leeftijden", value: "al", code: "al"},
    {nl_key: "leeftijd-6", name: "6 jaar en ouder", value: "6", code: "6"},
    {nl_key: "leeftijd-9", name: "9 jaar en ouder", value: "9", code: "9"},
    {nl_key: "leeftijd-12", name: "12 jaar en ouder", value: "12", code: "12"},
    {nl_key: "leeftijd-16", name: "16 jaar en ouder", value: "16", code: "16"},
    {nl_key: "geweld", name: "Geweld", value: "violence", code: "g"},
    {nl_key: "angst", name: "Angst", value: "scary", code: "a"},
    {nl_key: "seks", name: "Seks", value: "sex", code: "s"},
    {nl_key: "discriminatie", name: "Discriminatie", value: "discrimination", code: "d"},
    {nl_key: "drugs", name: "Drugs en/of alcoholmisbruik", value: "drugs", code: "h"},
    {nl_key: "grof-taalgebruik", name: "Grof taalgebruik", value: "language", code: "t"}
  ]
  class << self
    def search_url(search)
      "https://www.kijkwijzer.nl/zoeken/?query=#{url_encode(search)}&producties=0"
    end
    def get_content(search)
      Nokogiri::HTML(URI::open(search_url(search)))
    end

    # Search the Kijkwijzer database
    #
    # @return [Kijkwijzer::Result]
    def search(search, filter={})
      res = get_content(search)
      results = []
      res.css('.c-search__results .c-search__result').each do |result|
        r = Result.new_from_nokogiri_result_fragment(result)
        results << r if (r && r.match_filter?(filter))
      end
      results
    end
  end
end
