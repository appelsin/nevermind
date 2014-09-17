5.times do |i|
  Article.create vid: i*2,   content: 'article', rand: rand(1000)
  Video.create   vid: i*2+1, content: 'video',   rand: rand(1000)
end