module Kijkwijzer
  class Result
    attr_accessor :title
    attr_accessor :production_type
    attr_accessor :year
    attr_accessor :ratings

    # Get the ratings for the result
    #
    # @return [String] with kijkwijzer-ratings (English-language-labels)
    def ratings
      @ratings.collect do |rating|
        rating = rating.to_s.downcase
        rv = nil
        Kijkwijzer::POSSIBLE_RATINGS.each do |pr|
          rv = pr[:value] if (rating == pr[:value] or rating == pr[:code])
        end
        rv
      end.compact
    end

    def to_s
      "#<Kijkwijzer::Result @title=\"#{title}\", @year=#{year}>"
    end

    # Filters use a key value hash to which the results should conform
    #
    # @return [TrueClass, FalseClass]
    def match_filter?(filter)
      !(filter.collect{|k, v| include_r = (self.send(k) == v)}.include? false)
    end

    class << self
      def new_from_nokogiri_result_fragment nokogiri_result_fragment
        r = self.new
        r.title = nokogiri_result_fragment.css('.c-search__title').text
        production_type_year_match = nokogiri_result_fragment.css('.c-search__text').text.match(/\A\s*(.*)\s*\((\d\d\d\d)\)\s*$/)
        if production_type_year_match
          r.year = production_type_year_match[2].to_i if production_type_year_match[2]
          r.production_type = production_type_year_match[1].strip if production_type_year_match[1]
          r.ratings = nokogiri_result_fragment.css(".c-search__marks .c-search__mark").collect do |a|
            class_fragment = a.attr("class").match(/\Ac-search__mark\sc-search__mark--(.*)$/)[1]
            Kijkwijzer::POSSIBLE_RATINGS.find{|a| a[:nl_key] == class_fragment}&.[](:value)
          end.compact
          return r
        end
      end
    end
  end
end