class VideoProductMember < ActiveRecord::Base
  
  belongs_to :video
  belongs_to :video_product
  
  validates_presence_of :sequence
  validates_uniqueness_of :video_id
  before_validation :set_sequence
  before_destroy :update_sequences
  after_save :set_first_video
  
  private
  
  def set_first_video
    video_product.first_video = video if sequence == 1
    video_product.save
  end
  
  def set_sequence
    unless sequence
      last = VideoProductMember.where(:video_product_id => video_product_id).order(:sequence).last
      self.sequence = last ? last.sequence + 1 : 1
    end
  end
  
  
  def update_sequences
    Video.connection.execute("UPDATE video_product_members SET sequence = sequence - 1 WHERE sequence > #{sequence} AND video_product_id=#{video_product_id}")
  end
end