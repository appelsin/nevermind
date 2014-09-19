# Nevermind

Nevermind is purposed to proxy calls to multiple models

    @post = Nevermind::Proxy.new(Article.all, Video.all).find_by(slug: @slug)

## Installation

Add this line to your application's Gemfile:

    gem 'nevermind'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nevermind

## Usage

    @posts = Nevermind::Proxy.new(Article.all, Video.all)

As for version 0.0.2 it:

- Supports calls to proxied class that expected to return item from collection. This is done by default.
- Collection methods proxy
- ActiveRecord relation methods proxy

### Default behaviour

It delegates method calls to proxied classes if they not supposed to be "collection" or "relation methods".

When called returns not nil one:

    @posts.find_by(params) == Article.find_by(params) || Video.find_by(params)
    @posts.first
    
The "!" methods will return result witch doesn't raise exception:

    @posts.find_by! params
    @posts.first!
    
So, such method calls are class agnostioc.

### Collection methods

Only each and [] is supported at the moment. They are also class-agnostic:

    @posts.each { |post| post.do_something! }
    @posts[3]

### ActiveRecord relation methods

This methods can be used for ActiveRecord only

    @posts.where(title: title)
          .each { |post| post.do_something! }
          
    @posts.where(title: title)
          .order(:slug)
          .limit(10).offset(20)
          .each { |post| post.do_something! }
    
! Warning: params for ActiveRecord not yet carefully checked: be shure to pass ints to limit & 

## Future

- Implement ActiveRecord method group for Mongoid
- Support paginators like will_paginate & kaminari
- Class syntax like

######

    class Post < Nevermind::Something
        proxies Article
        proxies Video
    end
    
- Rails helpers like

######

    <%= nevermind @post, article:'articles/_item', video:'videos/_item' %>

## Contributing

1. Fork it ( https://github.com/appelsin/nevermind/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
