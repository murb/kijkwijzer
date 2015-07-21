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
end