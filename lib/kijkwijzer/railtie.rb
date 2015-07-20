require 'kijkwijzer/view_helpers'
module Kijkwijzer
  class Railtie < Rails::Railtie
    initializer "kijkwijzer.view_helpers" do
      ActionView::Base.send :include, Kijkwijzer::ViewHelpers
    end
  end
end

