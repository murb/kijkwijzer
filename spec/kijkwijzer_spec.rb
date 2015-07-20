require_relative 'spec_helper'

describe Kijkwijzer do
  it 'has a version number' do
    expect(Kijkwijzer::VERSION).not_to be nil
  end
  it 'can generate a search url' do
    expect(Kijkwijzer.search_url("aaa bbb")).to eq("http://www.kijkwijzer.nl/index.php?id=3__i&searchfor=aaa%20bbb&tab=KIJKWIJZER")
  end
  it 'can retrieve content' do
    if false
      res=Kijkwijzer.get_content("piano")
      expect(res.class).to eq(Nokogiri::HTML::Document)
      expect(res.css("title").text()).to eq("Classificaties - kijkwijzer.nl")
    end
  end
  it 'can filter content' do
    allow(Kijkwijzer).to receive(:get_content).with("piano").and_return(
      Nokogiri::HTML(open(File.join(Dir.pwd,'spec','fixture','piano_results.html')))
    )
    res=Kijkwijzer.search("piano")
    expect(res.count).to eq(10)
    res=Kijkwijzer.search("piano", {year: 2014})
    expect(res.count).to eq(2)
  end
  describe 'Result' do
    it "should handle ratings" do
      r = Kijkwijzer::Result.new
      r.ratings = ["AL"]
      expect(r.ratings).to eq(["al"])
      r.ratings = ["A"]
      expect(r.ratings).to eq(["scary"])
    end


  end

  describe 'helpers' do
    it 'can render svg definitions' do
      class TestView
        include Kijkwijzer::ViewHelpers
      end
      expect(TestView.new.render_kijkwijzer_svg_definitions[0..4]).to eq("<svg ")
    end
    it 'can render svg icons' do
      class TestView
        include Kijkwijzer::ViewHelpers
      end
      rating = Kijkwijzer::Result.new
      rating.ratings = ["AL"]
      kijkwijzer_svg_txt = TestView.new.render_kijkwijzers(rating)
      expect(kijkwijzer_svg_txt).to eq("<svg viewBox=\"0 0 100 100\" class=\"icon kijkwijzer rating kijkwijzer_al\"><use xlink:href=\"#kijkwijzer_base\"></use><use xlink:href=\"#kijkwijzer_al\"></use></svg>")
    end
  end
end
