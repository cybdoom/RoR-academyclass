class ProductFamily < ActiveRecord::Base
  belongs_to :product
  belongs_to :family
  validates_presence_of :product, :family
end
