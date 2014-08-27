class VideoFeature < ActiveRecord::Base
  belongs_to :video
  before_validation :set_position
  before_destroy :update_positions
  validates_presence_of :video, :position
  
  validates_uniqueness_of :video_id

  scope :for_linking, includes(:video => :video_products).order(:position).limit(7)
  
  private
  def set_position
    unless position
      last = VideoFeature.order('position').last
      self.position = last ? last.position + 1 : 1
    end
  end
  
  def update_positions
    VideoFeature.connection.execute("UPDATE video_features SET position=position-1 WHERE position > #{position}")
  end
end