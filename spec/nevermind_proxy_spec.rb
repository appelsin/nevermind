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

  it 'handles .order with single param' do
    posts = @posts.order :rand
    previous_post = false
    expect( posts.count ).to eq Article.count + Video.count
    posts.each do |post|
      unless false == previous_post
        expect(post.rand).to be >= previous_post.rand
      end
      previous_post = post
    end
  end

  it 'handles .order with single desc param' do
    posts = @posts.order :rand => :desc
    previous_post = false
    expect(posts.count).to eq Article.count + Video.count
    posts.each do |post|
      unless false == previous_post
        expect(post.rand).to be <= previous_post.rand
      end
      previous_post = post
    end
  end

  it 'handles .order with double param' do
    posts = @posts.order :id, :rand => :desc
    previous_post = false
    expect(posts.count).to eq Article.count + Video.count
    posts.each do |post|
      unless false == previous_post
        expect(post.id).to be >= previous_post.id
        if post.id == previous_post.id
          expect(post.rand).to be <= previous_post.rand
        end
      end
      previous_post = post
    end
  end

  it 'handles .limit' do
    posts = @posts.limit 5
    expect(posts.count).to eq 5
  end

  it 'handles []' do
    posts = @posts.order(:id)
    expect(posts[0].id).to eq 1
    expect(posts[1].id).to eq 1
    expect(posts[2].id).to eq 2
    expect(posts[3].id).to eq 2
  end

  it 'handles .offset' do
    last_post = @posts.limit(5)[4]
    posts = @posts.limit(5).offset(0)
    expect(posts.count).to eq 5
    expect(posts[4]).to eq last_post

    posts = @posts.order(:id).limit(4).offset(2)
    expect(posts[0].id).to eq 2
    expect(posts[1].id).to eq 2
    expect(posts[2].id).to eq 3
    expect(posts[3].id).to eq 3
    expect(posts[4]).to eq nil

  end

  it 'handles .order with .limit & .offset' do
    posts_offset_0 = @posts.order(:rand).limit(5)
    posts_offset_2 = @posts.order(:rand).limit(5).offset(2)

    expect(posts_offset_0.count).to eq 5
    expect(posts_offset_2.count).to eq 5

    [posts_offset_0, posts_offset_2].each do |posts|
      previous_post = false
      posts.each do |post|
        unless false == previous_post
          expect(post.rand).to be >= previous_post.rand
        end
        previous_post = post
      end
    end

    [0,1,2].each do |i|
      expect(posts_offset_2[i]).to be == posts_offset_0[i+2]
    end
  end
end