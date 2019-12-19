# newsapi.cr

NewsAPI in Crystal. https://newsapi.org/

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     newsapi:
       github: acoolstraw/newsapi.cr
   ```

2. Run `shards install`

## Usage

Let's make an example program that gets the top headlines about politics in the US. It also prints out the title of the 3rd article.

First, you need to have an API key from https://newsapi.org/
Once you get one, you need to require the library in your .cr file
```cr
require "newsapi"
```
Then, you need to enter your API key
```cr
News.key = "[your API key here]"
```
Then, you need to use the `#top_headlines` method
```cr
news = News.top_headlines(category: "politics", country: "us")
```
Finally, you print the title of the 3rd article by making sure `news` isn't nil and then printing it.
```cr
if news
    puts news.articles[2].title  
end
```
Overall, your code should look something like this
```cr
require "newsapi"

News.key = "[your API key here]"
news = News.top_headlines(category: "politics", country: "us")
if news
    puts news.articles[2]
end
```
View the documentation for in-depth explanations.

## Contributing

1. Fork it (<https://github.com/acoolstraw/newsapi/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [straw](https://github.com/acoolstraw) - creator and maintainer
- [z64](https://github.com/z64) - helped a ton with JSON parsing and optimization
- [Blacksmoke16](https://github.com/Blacksmoke16) - helped a ton with JSON parsing and optimization
