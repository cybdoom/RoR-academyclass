class VideoTag < ActiveRecord::Base
  belongs_to :video_tag_type
  belongs_to :video
  
  validates_presence_of :video_tag_type_id
  validates_presence_of :video_id
  validates_uniqueness_of :video_id, :scope => :video_tag_type_id

  before_save :set_sequence

  private

  def set_sequence
    unless sequence
      last = VideoTag.where(:video_tag_type_id => video_tag_type_id).order(:sequence).last
      self.sequence = last && last.sequence ? last.sequence + 1 : 1
    end
  end
end