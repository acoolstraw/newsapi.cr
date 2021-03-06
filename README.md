# newsapi.cr [ABANDONED]

NewsAPI in Crystal

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     newsapi:
       github: acoolstraw/newsapi-crystal
   ```

2. Run `shards install`

## Usage

Let's go over the shard's functions:

First, you need to have an API key from https://newsapi.org/
Once you get one, you need to require the shard in your .cr file (after installing the shard, of course)
```cr
require "newsapi"
```
Then, you need to initialize a News class (init_var can be whatever you want)
```cr
init_var = News.new("YOUR-API-KEY-HERE")
```
And you're done! Now you can do whatever is possible with NewsAPI!
### #get_top_headlines
```cr
# Looks for top headlines containing "bitcoin" in the US
headlines = News.get_top_headlines(q: "bitcoin", country: "us")
# Looks for top headlines from BBC and New Scientist. Page 2 of the results
headlines = News.get_top_headlines(sources: "bbc-news, new-scientist", page: 2)
# Gets top headlines in the category business, amount of results (in request) is 100.
headlines = News.get_top_headlines(category: "business", page_size: 100)
```
You cannot mix `sources` with `country` or `category`. All parameters are presented in the above example. Additional information about this method is available at <https://newsapi.org/docs/endpoints/top-headlines>.

### #get_everything
```cr
# Gets everything, must contain "colorado" in title and everywhere else
everything = News.get_everything(q: "colorado", q_in_title: "colorado")
# Gets everything from TechCrunch and Engadget, sorts by relevancy
everything = News.get_everything(sources: "techcrunch, engadget", sort_by: "relevancy")
# Gets everything from cnn.com from 2020-01-05 to 2020-01-10 (date must be in ISO 8601 format)
everything = News.get_everything(domains: "cnn.com", from: "2020-01-05", to: "2020-01-10")
# Gets everything not from bloomberg.com in English with page size 40 and on page 2
everything = News.get_everything(exclude_domains: "bloomberg.com", language: "en", pageSize: 40, page: 2)
```
Same things apply to this method as do to #get_top_headlines. Additional information about this method is available at <https://newsapi.org/docs/endpoints/everything>

### #get_sources
```cr
# Gets English news sources in the business category
sauces = News.get_sources(category: "business", language: "en")
# Gets all sources from Russia
sauces = News.get_sources(country: "ru")
```
All parameters are presented in the above example. Additional information about this method is available at <https://newsapi.org/docs/endpoints/sources>

### Interacting with the output
Since Crystal is a type-safe language, you'll need to do this before interacting with the output
For #get_top_headlines and #get_everything:
```cr
if articles = init_var.try(&.articles)
    # your code ...
end
```
For #get_sources
```cr
if sources = init_var.try(&.sources)
    # your code ...
end
```
Now, you can just grab values from the JSON output like this
For #get_top_headlines and #get_everything
```cr
    puts status # gets status, can be either ok or error, the latter would ideally print an error message in the console
    puts totalResults # gets number of total results
    puts articles[1].source.id # gets source ID of second article in results
    puts articles[1].source.name # gets source name of second article in results
    puts articles[5].author # gets name of author of sixth article
    puts articles[0].title # gets title of first article
    puts articles[4].description # gets description of fifthth article
    puts articles[3].url # gets url of fourth article
    puts articles[5].urlToImage # gets URL to thumbnail/image of sixth article
    puts articles[0].publishedAt # gets date of publication of first article
    puts articles[3].content # gets content (limited for developer plan users)
```
For #get_sources
```cr
    puts status # gets status
    puts sources[1].id # gets id of second source
    puts sources[3].name # gets name of fourth source
    puts sources[2].description # gets description of third source
    puts sources[5].url # gets url of sixth source
    puts sources[0].category # gets category of first source
    puts sources[4].language # gets language of fifth source
    puts sources[3].country # gets country of fourth source
```

Seems like this is all. Have fun!

## Contributing

1. Fork it (<https://github.com/acoolstraw/newsapi.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Changelog

### 1.1.0:
- changed way of entering API key from class property to initialization
- added a lot more docs
- I need sleep

### 1.0.0:
- renamed #top_headlines to #get_top_headlines
- added #get_sources
- added error messages
- added `page` parameter support in #get_top_headlines and #get_everything
- covered all NewsAPI endpoints
- made small adjustments

## Contributors

- [straw](https://github.com/acoolstraw) - creator and maintainer
- [z64](https://github.com/z64) - helped a ton with JSON parsing and optimization
- [Blacksmoke16](https://github.com/Blacksmoke16) - helped a ton with JSON parsing and optimization
