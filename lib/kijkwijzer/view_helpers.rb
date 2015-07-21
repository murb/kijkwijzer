module Kijkwijzer

  # ViewHelpers for Rails
  module ViewHelpers

    # Renders the SVG definitions with all Kijkwijzer icons. To be placed somewhere in the top of your body,
    # for optimal compatibility
    #
    # @return String html-string, made html_safe if ActiveSupport is defined.
    def render_kijkwijzer_svg_definitions
      svg_txt = File.open(open(File.join(File.dirname(__FILE__),'..','kijkwijzer.svg'))).read
      svg_txt = svg_txt.html_safe if defined?(ActiveSupport)
      svg_txt
    end

    # Renders a div block with svg elements that references the definition as defined by #render_kijkwijzer_svg_definitions
    #
    # rating_result is an actual Kijkwijzer::Result or an array of ratings similar to the result of Result#ratings
    # @return String html-string, made html_safe if ActiveSupport is defined.
    def render_kijkwijzers rating_result
      result_svgs = "<div class=\"kijkwijzer icons\">"
      if rating_result.is_a? Kijkwijzer::Result
        rating_result = rating_result.ratings
      end
      rating_result.each do |rating|
        result_svgs+="<svg viewBox=\"0 0 100 100\" class=\"icon kijkwijzer_#{rating}\" title=\"#{rating}\"><use xlink:href=\"#kijkwijzer_base\"></use><use xlink:href=\"#kijkwijzer_#{rating}\"></use></svg>"
      end
      result_svgs += "</div>"
      result_svgs = result_svgs.html_safe if defined?(ActiveSupport)
      result_svgs
    end
  end
end