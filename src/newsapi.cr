require "http"
require "json"
class Source
    JSON.mapping(
        id: String?,
        name: String?
    )
end
class Sources
    JSON.mapping(
        id: String?,
        name: String?,
        description: String?,
        url: String?,
        category: String?,
        language: String?,
        country: String?
    )
end
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
class NewsJSON
    JSON.mapping(
        status: String?,
        code: String?,
        message: String?,
        totalResults: Int32 | Nil,
        articles: Array(Article)?,
        article: Article | Nil
    )
end
class SourcesJSON
    JSON.mapping(
        status: String?,
        code: String?,
        message: String?,
        sources: Array(Sources)?
    )
end
class News
    VERSION = "v2"
    BASE_URL = "https://newsapi.org/" + VERSION + "/"
    def initialize(@key : String)
    end
    def get_top_headlines(q = nil, country = nil, category = nil, sources = nil, page_size = nil, page = nil)
        api_key = @key
        top_headlines_url = BASE_URL + "top-headlines?"
        params = HTTP::Params.build do |form|
            form.add("q", q) if q
            form.add("country", country) if country
            form.add("category", category) if category
            form.add("sources", sources) if sources
            form.add("pageSize", page_size.to_s) if page_size
            form.add("page", page.to_s) if page
        end
        top_headlines_url += params
        if api_key
            response = HTTP::Client.get(top_headlines_url, headers: HTTP::Headers{"X-Api-Key" => api_key.not_nil!})
            content = NewsJSON.from_json(response.body)
            if content.status
                unless content.status == "ok"
                    puts "[ERROR] #{content.code}: #{content.message}"
                else
                    return content
                end
            end
        end
    end
    def get_everything(q = nil, q_in_title = nil, sources = nil, domains = nil, exclude_domains = nil, from = nil, to = nil, language = nil, sort_by = nil, page_size = nil, page = nil)
        api_key = @key
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
            form.add("pageSize", page_size.to_s) if page_size
            form.add("page", page.to_s) if page
        end
        get_everything_url += params
        if api_key
            response = HTTP::Client.get(get_everything_url, headers: HTTP::Headers{"X-Api-Key" => api_key.not_nil!})
            content = NewsJSON.from_json(response.body)
            if content.status
                unless content.status == "ok"
                    puts "[ERROR] #{content.code}: #{content.message}"
                else
                    return content
                end
            end
        end
    end
    def get_sources(category = nil, language = nil, country = nil)
        api_key = @key
        get_sources_url = BASE_URL + "sources?"
        params = HTTP::Params.build do |form|
            form.add("category", category) if category
            form.add("language", language) if language
            form.add("country", country) if country
        end
        get_sources_url += params
        if api_key
            response = HTTP::Client.get(get_sources_url, headers: HTTP::Headers{"X-Api-Key" => api_key.not_nil!})
            content = SourcesJSON.from_json(response.body)
            if content.status
                unless content.status == "ok"
                    puts "[ERROR] #{content.code}: #{content.message}"
                else
                    return content
                end
            end
        end
    end
end
