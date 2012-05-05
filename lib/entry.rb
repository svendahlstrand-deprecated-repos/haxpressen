require 'mongoid'

Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db('haxpressen')
end

# Represents an entry on HN
class Entry
  include Mongoid::Document

  field :title, type: String
  field :date, type: Date
  field :url, type: String
  field :comments_url, type: String
  field :points, type: Integer
end
