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
  end
end