class FooterLink < ActiveRecord::Base
  belongs_to :product
  validates_presence_of :product
  validates_uniqueness_of :product_id

  scope :with_products, includes(:product => :product_parent)
  scope :ordered, order("products.name")
end
