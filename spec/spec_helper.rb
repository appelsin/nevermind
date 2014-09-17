require 'active_record'
require 'nevermind'

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

load File.dirname(__FILE__) + '/schema.rb'
require File.dirname(__FILE__) + '/models.rb'
require File.dirname(__FILE__) + '/seed.rb'