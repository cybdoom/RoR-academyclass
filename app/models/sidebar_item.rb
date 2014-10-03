class SidebarItem < ActiveRecord::Base
  validates_presence_of :title, :content, :position

  default_scope :order => 'position'

  acts_as_list :column => 'position'

  before_create :set_last_position

  private

    def set_last_position
      self.position = (SidebarItem.maximum(:position) || 0) + 1
    end
end
