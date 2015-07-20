module Kijkwijzer
  module ViewHelpers
    def render_kijkwijzer_svg_definitions
      svg_txt = File.open(open(File.join(File.dirname(__FILE__),'..','kijkwijzer.svg'))).read
      svg_txt = svg_txt.html_safe if defined?(ActiveSupport)
      svg_txt
    end
    def render_kijkwijzers result
      result_svgs = ""
      result.ratings.each do |rating|
        result_svgs+="<div class=\"kijkwijzer icons\"><svg viewBox=\"0 0 100 100\" class=\"icon kijkwijzer_#{rating}\" title=\"#{rating}\" ><use xlink:href=\"#kijkwijzer_base\"></use><use xlink:href=\"#kijkwijzer_#{rating}\"></use></svg></div>"
      end
      result_svgs
      result_svgs = result_svgs.html_safe if defined?(ActiveSupport)
      result_svgs
    end
  end
end