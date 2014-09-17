5.times do |i|
  Article.create vid: i*2,   content: 'article'
  Video.create   vid: i*2+1, content: 'video'
end