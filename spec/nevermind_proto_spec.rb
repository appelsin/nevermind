require File.dirname(__FILE__) + '/spec_helper.rb'

describe Nevermind::Proxy do
  before :all do
    @posts = Nevermind::Proxy.new(Article, Video)
  end
  
  it 'handles find_by' do
    post = @posts.find_by(content: 'article')
    expect(post.class).to eq Article
    post = @posts.find_by(content: 'video')
    expect(post.class).to eq Video
  end

  it 'handles find_by!' do
    post = @posts.find_by!(content: 'article')
    expect(post.class).to eq Article
    post = @posts.find_by!(content: 'video')
    expect(post.class).to eq Video
  end

  it 'handles first' do
    post = @posts.first
    expect(post.class).to satisfy { |klass| [Article, Video].include? klass }
  end

  it 'handles first!' do
    post = @posts.first
    expect(post.class).to satisfy { |klass| [Article, Video].include? klass }
  end

  it 'handles where' do
    post = @posts.where(content: 'article').first
    expect(post.class).to eq Article
    post = @posts.where(content: 'video').first
    expect(post.class).to eq Video
  end

  it 'handles all' do
    post = @posts.all.first
    expect(post.class).to satisfy { |klass| [Article, Video].include? klass }
  end
end