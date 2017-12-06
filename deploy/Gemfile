source 'https://rubygems.org'

require 'json'
require 'open-uri'
versions = JSON.parse(open('./versions.json').read)

gem 'github-pages', versions['github-pages'], group: :jekyll_plugins

# If you have any plugins, put them here!
group :jekyll_plugins do
  gem 'rouge', versions['rouge']
  gem 'jekyll-mentions', versions['jekyll-mentions']
  gem 'jekyll-sitemap', versions['jekyll-sitemap']
  gem 'jekyll-gist', versions['jekyll-gist']
  gem 'jekyll-paginate', versions['jekyll-paginate']
  gem 'html-proofer'
end
