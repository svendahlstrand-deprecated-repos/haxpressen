# Represents a single entry on Hackernytt
class Entry
  include Mongoid::Document

  field :title, type: String
  field :date, type: Date
  field :url, type: String
  field :comments_url, type: String
  field :points, type: Integer
end
