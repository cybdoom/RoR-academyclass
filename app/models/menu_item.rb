class MenuItem < ActiveRecord::Base
  belongs_to :menu_group
  validates_presence_of :menu_group, :label, :url, :sequence
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\Z/
  has_attached_file :logo, :styles => {icon: "15x15#"}, default_url: "/images/:style/missing.png"
  attr_accessible :menu_group, :label, :url, :sequence, :menu_group_id, :logo
  


  before_validation :set_sequence

  private

  def set_sequence
    unless sequence
      last = menu_group.menu_items.last
      self.sequence = last ? last.sequence + 1 : 1
    end
  end
end
