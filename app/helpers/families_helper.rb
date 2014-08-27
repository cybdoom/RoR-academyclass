module FamiliesHelper
  def image_column(family)
    return image_tag family.image.url
    
  end
end
