class SurveyProduct < ActiveRecord::Base
  validates_presence_of :product, :product_parent
  validates_uniqueness_of :product, :scope => :product_parent
  
  def display
    return "#{self.product_parent} #{self.product}"
  end
end
