class NewsPage < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged
  attr_accessible :title, :body

  validates_presence_of :title, :body, :slug
  validates_uniqueness_of :title
  validates_uniqueness_of :slug
end
