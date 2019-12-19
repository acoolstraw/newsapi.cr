require "http"
require "json"

# Contains `id` of the site and its `name`
class Source
    JSON.mapping(
        id: String?,
        name: String?
    )
end

# An article may contain the following:
# - `source`: `id` and `name`, look at the Source class for more info
# - `author`
# - `title`
# - `description`
# - `url`: Link to article
# - `urlToImage`: Link to image of article
# - `publishedAt`: Date of publication
# - `content`: Content, limited to 260 characters for free plan users
# Usage:
# ```cr
# # print out author of 7th article in result, unless nil
# if news
#     puts news.articles[6].author
# end
# # print out description of 20th article in result, unless nil
# if news
#     puts news.articles[19].description
# end
# ```
class Article
    JSON.mapping(
        source: Source,
        author: String?,
        title: String?,
        description: String?,
        url: String?,
        urlToImage: String?,
        publishedAt: String?,
        content: String?
    )
end

# /top_headlines crystalized JSON body
# Contains the following
# - status: Status of the request
# - totalResults: Number of articles in response
# - articles: An array of articles
# - article: In case there's only one result
class NewsJSON
    JSON.mapping(
      status: String?,
      totalResults: Int32,
      articles: Array(Article),
      article: Article?
    )
end

# The News class handles endpoints, authentication and errors.
# Usage:
# ```cr
# News.key = "Your API key"
# ```
# From there on, you can use endpoint methods.
class News
    VERSION = "v2"
    BASE_URL = "https://newsapi.org/" + VERSION + "/"
    class_property key : String? = nil
    # Gets top headlines.
    # Must have at least one of the following arguments:
    # - `q`: Keyword or phrase to search for
    # - `country`: The ISO 3166-1 code of the country you want news from, e.g. `us`, `bg`, `gb`, `ca`, `jp`, `br`)
    # - `category`: Category you want news about
    # - `sources`: Comma-separated string of identifiers for the news sources or blogs you want headlines from. Use the /sources endpoint to locate these programmatically. **Note: You can't mix this param with the `country` or `category` params.**
    # - `page_size`: The number of results to return per request (page). 20 is the default, 100 is the maximum.
    # - `page`: TODO (coming soon)
    # Usage:
    # ```cr
    # News.key = "Your API key"
    # news = News.top_headlines(country: "us", category: "politics")
    # ```
    def self.top_headlines(q = nil, country = nil, category = nil, sources = nil, page_size = nil)
        api_key = @@key
        top_headlines_url = BASE_URL + "top-headlines?"
        params = HTTP::Params.build do |form|
          form.add("q", q) if q
          form.add("country", country) if country
          form.add("category", category) if category
          form.add("sources", sources) if sources
          form.add("pageSize", page_size) if page_size
        end
        top_headlines_url += params
        if api_key
            response = HTTP::Client.get(top_headlines_url, headers: HTTP::Headers{"X-Api-Key" => api_key})
            content = NewsJSON.from_json(response.body)
        end
    end
    # Gets everything from over 30000 sources
    # Must have at least one of the following arguments:
    # - `q`: Keyword or phrase to search for
    # - `q_in_title`: Only search for keyword or phrase in the title
    # - `sources`: Comma-separated string of `id`s for the news sources or blogs you want headlines from. Use the /sources endpoint to locate these programmatically.
    # - `domains`: Domains separated by commas (e.g. `domains: "bbc.co.uk, cnn.com, techcrunch.com"`) to get results from
    # - `exclude_domain`: Exclude domains from results
    # - `from`: Oldest date result can be from, must be in ISO 8601 format (e.g. 2019-12-19 or 2019-12-19T06:18:33)
    # - `to`: Newest date result can be from, has same format requirements as `from`
    # - `language`: Language of article
    # - `sort_by`: Sort by `relevancy` (articles most closely related to `q` come first), `popularity`, `publishedAt` (newest articles come first)
    # - `page_size`: The number of results to return per request (page). 20 is the default, 100 is the maximum.
    # Usage:
    # ```cr
    # News.key = "Your API key"
    # news = News.get_everything(domains: "cnn.com, techcrunch.com, news.ycombinator.com", sort_by: "popularity")
    # ```
    def self.get_everything(q = nil, q_in_title = nil, sources = nil, domains = nil, exclude_domains = nil, from = nil, to = nil, language = nil, sort_by = nil, page_size = nil)
        api_key = @@key
        get_everything_url = BASE_URL + "everything?"
        params = HTTP::Params.build do |form|
          form.add("q", q) if q
          form.add("qInTitle", q_in_title) if q_in_title
          form.add("sources", sources) if sources
          form.add("domains", domains) if domains
          form.add("excludeDomains", exclude_domains) if exclude_domains
          form.add("from", from) if from
          form.add("to", to) if to
          form.add("language", language) if language
          form.add("sortBy", sort_by) if sort_by
          form.add("pageSize", page_size) if page_size
        end
        get_everything_url += params
        if api_key
            response = HTTP::Client.get(get_everything_url, headers: HTTP::Headers{"X-Api-Key" => api_key})
            content = NewsJSON.from_json(response.body)
        end
    end
end