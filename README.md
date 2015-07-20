# Kijkwijzer

[Kijkwijzer](http://kijkwijzer.nl) is the [Dutch film/television-screening system](https://en.wikipedia.org/wiki/Television_content_rating_systems#Netherlands). Since there is no proper API i made this gem to remove the scraping bit from my own app-source.

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

### Rails helpers

To make things even easier I included the SVG-icon set. Simply use the two methods.

Within the html's head, load the iconset definition:

```ruby
<%= render_kijkwijzer_svg_definitions %>
```
Then for each movie:

```ruby
<%= render_kijkwijzers ratings %>
```

(where ratings is a single result object)


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/kijkwijzer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
