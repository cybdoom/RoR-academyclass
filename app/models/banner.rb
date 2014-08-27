class Banner < ActiveRecord::Base
  has_attached_file :banner
  validates_presence_of :banner_file_name, :url, :position
  
  before_validation :set_position, :on => :create
  
  def set_position
    last = Banner.first(:order => "position DESC")
    self.position = last ? last.position + 1 : 1
  end
end