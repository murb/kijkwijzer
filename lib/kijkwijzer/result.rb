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
        r.title = nokogiri_result_fragment.css('b').text
        production_type_match = nokogiri_result_fragment.text.match(/Productietype\:\s(.*)\.(\sProductie)/)
        production_year_match = nokogiri_result_fragment.text.match(/\sProductiejaar\:\s(\d\d\d\d)\.\s/)
        r.year = production_year_match[1].to_i if production_year_match
        r.production_type = production_type_match[1] if production_type_match
        r.ratings = nokogiri_result_fragment.css("img").collect{|a| a.attr("src").match(/\/upload\/pictogrammen\/\d*_\d*_(.*)\.png/)[1]}
        return r
      end
    end
  end
end