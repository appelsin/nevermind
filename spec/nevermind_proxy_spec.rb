require File.dirname(__FILE__) + '/spec_helper.rb'

describe Nevermind::Proxy do
  before :all do
    @posts = Nevermind::Proxy.new(Article.all, Video.all)
  end

  it 'handles .find_by & .find_by!' do
    [
        [Article, @posts.find_by!(content: 'article')],
        [Video,   @posts.find_by!(content: 'video')],
        [Article, @posts.find_by(content: 'article')],
        [Video,   @posts.find_by(content: 'video')]
    ].each do |klass, post|
      expect(post.class).to eq klass
    end
  end

  it 'handles .first' do
    post = @posts.first
    expect(post.class).to satisfy { |klass| [Article, Video].include? klass }
  end

  it 'handles .first!' do
    post = @posts.first!
    expect(post.class).to satisfy { |klass| [Article, Video].include? klass }
  end

  it 'handles .where' do
    [
        [ Article, @posts.where(content: 'article') ],
        [ Video,   @posts.where(content: 'video')   ]
    ].each do |klass, posts|
      expect(posts.class).to eq Nevermind::Proxy
      post = posts.first
      expect(post.class).to eq klass
    end
  end

  it 'handles .all' do
    posts = @posts.all
    expect(posts.class).to eq Nevermind::Proxy
    post = posts.first
    expect(post.class).to satisfy { |klass| [Article, Video].include? klass }
  end

  it 'handles .each' do
    vid = 0
    count = 0
    vid_expectation = Article.all.map(&:vid).reduce(&:+) + Video.all.map(&:vid).reduce(&:+)
    count_expectation = Article.count + Video.count
    @posts.each { |post| vid+= post.vid; count+= 1 }
    expect(count).to eq (count_expectation)
    expect(vid).to eq (vid_expectation)
  end

  it 'handles .count' do
    count = Article.all.count + Video.all.count
    expect(@posts.count).to eq count
  end

  xit 'handles .order' do
    posts = @posts.order :rand
    previous_post = false
    posts.each do |post|
      unless false == previous_post
        expect(post.rand).to be >= previous_post.rand
      end
      previous_post = post
    end
  end

  xit 'handles .limit' do
    posts = @posts.limit 5
    $stderr.puts posts.all.inspect
    expect(posts.all.count).to eq 5
  end
end