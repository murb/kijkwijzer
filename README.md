# Kijkwijzer

[Kijkwijzer](http://kijkwijzer.nl) is the [Dutch film/television-screening system](https://en.wikipedia.org/wiki/Television_content_rating_systems#Netherlands). Since there is no proper API, this gem was made to remove the scraping bit from my own app-source. Additionally some helper methods have been added to make displaying the icons easier (the icons are included in this gem as a SVG-iconset).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kijkwijzer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kijkwijzer

## Usage

Usage is simple:

```ruby
Kijkwijzer.search("piano")
```

Gives you results of movies, documentaries etc with known ratings.

You can also filter by year:

```ruby
Kijkwijzer.search("piano", {year: 2011})
```

### Rails view-helpers (SVG icons)

To make things even easier I included the SVG-icon set. Simply use the two methods.

Somewhere in the top of your body, load the iconset definition:

```ruby
<%= render_kijkwijzer_svg_definitions %>
```
Then to display the movie results use the view helper `render_kijkwijzers`:

```ruby
<% Kijkwijzer.search("piano").each do |rating| %>
<h2><%= rating.title %></h2>
<p><%= render_kijkwijzers rating %></p>
<% end %>
```

Make sure you format the icons properly, otherwise you'll get huge icons ... I believe I've added plenty of classes for easy styling using css.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/murb/kijkwijzer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
