require File.dirname(__FILE__) + '/spec_helper.rb'

describe Nevermind::Proto do
  it 'passes find_by' do
    posts = Nevermind::Proto.new(Article, Video)
    post = posts.find_by(content: 'article')
    expect(post.class).to eq Article
    post = posts.find_by(content: 'video')
    expect(post.class).to eq Video
  end

  it 'passes find_by!' do
    posts = Nevermind::Proto.new(Article, Video)
    post = posts.find_by!(content: 'article')
    expect(post.class).to eq Article
    post = posts.find_by!(content: 'video')
    expect(post.class).to eq Video
  end

  it 'passes first' do
    posts = Nevermind::Proto.new(Article, Video)
    post = posts.first
    expect(post.class).to satisfy { |klass| [Article, Video].include? klass }
  end

  it 'passes first!' do
    posts = Nevermind::Proto.new(Article, Video)
    post = posts.first
    expect(post.class).to satisfy { |klass| [Article, Video].include? klass }
  end
end