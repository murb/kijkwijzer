require_relative 'spec_helper'

describe Kijkwijzer do
  it 'has a version number' do
    expect(Kijkwijzer::VERSION).not_to be nil
  end
  it 'can generate a search url' do
    expect(Kijkwijzer.search_url("aaa bbb")).to eq("http://www.kijkwijzer.nl/index.php?id=3__i&searchfor=aaa%20bbb&tab=KIJKWIJZER")
    expect(Kijkwijzer.search_url("piano")).to eq("http://www.kijkwijzer.nl/index.php?id=3__i&searchfor=piano&tab=KIJKWIJZER")
  end
  describe 'full stack' do
    if false
      it 'can retrieve content' do
        res=Kijkwijzer.get_content("Wildlife")
        expect(res.class).to eq(Nokogiri::HTML::Document)
        expect(res.css("title").text()).to eq("Classificaties - kijkwijzer.nl")
      end
      it 'can search' do
        title = "Wildlife"
        options = {}
        res = Kijkwijzer.search(title, options)
        expect(res[0].title).to eq("Wildlife")
      end
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
    expect(res[1].production_type).to eq("Speelfilm")
    expect(res[1].ratings).to eq(["12","violence","language"])
  end
  describe "faulty response handling" do
    it 'can deal with empty response' do
      allow(Kijkwijzer).to receive(:get_content).with("piano").and_return(
        Nokogiri::HTML(open(File.join(Dir.pwd,'spec','fixture','failure.html')))
      )
      res=Kijkwijzer.search("piano")
      expect(res.count).to eq(0)
      res=Kijkwijzer.search("piano", {year: 2014})
      expect(res.count).to eq(0)
    end
    it 'can deal with unexpected description' do
      allow(Kijkwijzer).to receive(:get_content).with("piano").and_return(
        Nokogiri::HTML(open(File.join(Dir.pwd,'spec','fixture','unexpected_description.html')))
      )
      res=Kijkwijzer.search("piano")
      expect(res.count).to eq(10)
      res=Kijkwijzer.search("piano", {year: 2014})
      expect(res.count).to eq(0)
    end
  end
  describe 'Result' do
    it "should handle ratings" do
      r = Kijkwijzer::Result.new
      r.ratings = ["AL"]
      expect(r.ratings).to eq(["al"])
      r.ratings = ["A"]
      expect(r.ratings).to eq(["scary"])
    end
    it "should reject invalid ratings" do
      r = Kijkwijzer::Result.new
      r.ratings = ["ALt"]
      expect(r.ratings).to eq([])
      r.ratings = ["17"]
      expect(r.ratings).to eq([])
    end

  end

  describe 'helpers' do
    require 'kijkwijzer/view_helpers' #otherwise done by the railtie, which we're skipping for now


    it 'can render svg definitions' do
      class TestView
        include Kijkwijzer::ViewHelpers
      end
      expect(TestView.new.render_kijkwijzer_svg_definitions[0..4]).to eq("<svg ")
    end
    it 'can render svg icons from result' do
      class TestView
        include Kijkwijzer::ViewHelpers
      end
      rating = Kijkwijzer::Result.new
      rating.ratings = ["AL"]
      kijkwijzer_svg_txt = TestView.new.render_kijkwijzers(rating)
      expect(kijkwijzer_svg_txt).to eq("<div class=\"kijkwijzer icons\"><svg viewBox=\"0 0 100 100\" class=\"icon kijkwijzer_al\" title=\"al\"><use xlink:href=\"#kijkwijzer_base\"></use><use xlink:href=\"#kijkwijzer_al\"></use></svg></div>")
    end
    it 'can render svg icons from empty array' do
      class TestView
        include Kijkwijzer::ViewHelpers
      end
      # rating = Kijkwijzer::Result.new
      rating = []
      kijkwijzer_svg_txt = TestView.new.render_kijkwijzers(rating)
      expect(kijkwijzer_svg_txt).to eq("<div class=\"kijkwijzer icons\"></div>")
    end
    it 'can render svg icons from filled array' do
      class TestView
        include Kijkwijzer::ViewHelpers
      end
      # rating = Kijkwijzer::Result.new
      rating = ["6","scary"]
      kijkwijzer_svg_txt = TestView.new.render_kijkwijzers(rating)
      expect(kijkwijzer_svg_txt).to eq("<div class=\"kijkwijzer icons\"><svg viewBox=\"0 0 100 100\" class=\"icon kijkwijzer_6\" title=\"6\"><use xlink:href=\"#kijkwijzer_base\"></use><use xlink:href=\"#kijkwijzer_6\"></use></svg><svg viewBox=\"0 0 100 100\" class=\"icon kijkwijzer_scary\" title=\"scary\"><use xlink:href=\"#kijkwijzer_base\"></use><use xlink:href=\"#kijkwijzer_scary\"></use></svg></div>")
    end
  end
end
