ActiveRecord::Schema.define do
  self.verbose = false

  create_table :articles, :force => true do |t|
    t.integer :vid
    t.integer :rand
    t.string :content

    t.timestamps
  end

  create_table :videos, :force => true do |t|
    t.integer :vid
    t.integer :rand
    t.string :content

    t.timestamps
  end

end