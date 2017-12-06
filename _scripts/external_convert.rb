EXTERNAL_POSTS = [
  {:date => "2015-03-02", :url => "https://testweb.com/testlink", :title => "Some title"}
]

POST_TEMPLATE = <<eos
---
layout: post
title: "__TITLE__"
tags:
- External Writing
- __TAG__
thumbnail_path: "blog/thumbs/__THUMB__"
external_url: "__URL__"
---  

__EXCERPT__:

{% include figure.html path=page.thumbnail_path caption=page.title url=page.external_url %}

eos

POST_ATTRIBUTES_MAP = [
  {
    :url_regex => /.+quora.+/, 
    :thumb => "quora-logo.png", 
    :tags => "Startups",
    :excerpt => "My answer on Quora to [{{ page.title }}]({{ page.external_url }})"
  },
  {
    :url_regex => /.+engineering\.linkedin\.com/,
    :thumb => "linkedin-blueprint.jpg", 
    :tags => "Software Engineering",
    :excerpt => "A blog post I wrote on the LinkedIn Engineering Blog about [{{ page.title }}]({{ page.external_url }}):"
  },
  {
    :url_regex => /.+reddit.+/,
    :thumb => "reddit-alien.png",
    :tags => "Startups",
    :excerpt => "My answer on Reddit to [{{ page.title }}]({{ page.external_url }})"
  },
  {
    :url_regex => /.*/,
    :thumb => "",
    :tags => "",
    :excerpt => ""
  }
]

def slugify(text)
  text.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
end

def post_content(post)
  post_attributes = POST_ATTRIBUTES_MAP.find do |attrs|
    post[:url] =~ attrs[:url_regex]
  end

  POST_TEMPLATE
    .sub("__TITLE__", post[:title])
    .sub("__TAG__", post_attributes[:tags])
    .sub("__THUMB__", post_attributes[:thumb])
    .sub("__URL__", post[:url])
    .sub("__EXCERPT__", post_attributes[:excerpt])
end

EXTERNAL_POSTS.each do |post|
  slug = slugify(post[:title])
  file_path = "_posts/#{post[:date]}-#{slug}.md"
  content = post_content(post)
  
  puts "Writing #{file_path}"
  IO.write(file_path, content) 
end




