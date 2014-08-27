class Family < ActiveRecord::Base
  has_many :product_families, :dependent => :destroy, :order => :position
  has_many :products, :through => :product_families
  has_attached_file :family_image
  has_attached_file :header_image
  validates_presence_of :name, :slug, :short_name, :tagline
  default_scope :order => 'position'
  acts_as_list :column => 'position'

  scope :with_products, includes(:products => :product_parent)
  
  def set_products(products)
    products.each_with_index do |product, i|
      update_or_create_product(product.to_i, i+1)
    end
    self.product_families.each do |pf|
      pf.destroy unless products.include?(pf.product_id.to_s)
    end
    save
  end

  private
  def update_or_create_product(product_id, position)
    self.product_families.each do |pf|
      if product_id == pf.product_id
        pf.update_attribute(:position, position) unless pf.position == position
        return
      end
    end
    self.product_families << ProductFamily.new({:product_id => product_id, :position => position})
  end
end