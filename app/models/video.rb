class Video < ActiveRecord::Base
  validates_presence_of :title
  has_many :video_product_members, :dependent => :destroy
  has_many :video_products, :through => :video_product_members
  has_many :video_tags, :dependent => :destroy
  has_many :video_tag_types, :through => :video_tags
  validates_format_of :thumbnail, :with => /^http:\/\//
  validates_format_of :image, :with => /^http:\/\//
  accepts_nested_attributes_for :video_products
  accepts_nested_attributes_for :video_tag_types
  
  def user_has_video_access?(user)
    return true if free
    return true if user && user.backend_access?
    vp = video_product
    return true if vp && vp.free
    return false if !user || !vp
    return user.video_product_ids.include?(vp.id)
  end
  
  def video_product
    video_products.empty? ? nil : video_products.first
  end
  
  def full_title
    vp = video_products.first
    vp.nil? ? title : "#{vp.name} - #{title}"
  end
  
  def instructor
    video_tag_types.select {|vtt| vtt.category == VideoTagType::INSTRUCTOR }.first
  end
  
  def length
    return duration ? "#{duration / 60}:#{"%02d" % (duration % 60)}" : nil
  end
  
  def self.starting_with(letter)
    clause = letter == "0-9" ? "REGEXP '^[^a-zA-Z]'" : "LIKE '#{letter[0,1]}%'"
    where("title #{clause}")
  end

  def self.vimeo_video
    #base = Vimeo::Advanced::Base.new(VIMEO_CONSUMER_KEY, VIMEO_CONSUMER_SECRET)
    Vimeo::Advanced::Video.new(VIMEO_CONSUMER_KEY, VIMEO_CONSUMER_SECRET, :token => VIMEO_USER_TOKEN, :secret => VIMEO_USER_SECRET)
  end
  
  def self.download_all_videos
    vimeo = Video.vimeo_video
    page = 1
    videos = vimeo.get_all("academyclass", {:page => page})
    videos = videos["videos"]["video"]
    while !videos.empty?
      videos.each do |v|
        puts "Creating video #{v["title"]}"
        Video.create!({:title => v["title"], :vimeo_code => v["id"], :description => v["description"]})
      end
      page += 1
      videos = vimeo.get_all("academyclass", {:page => page})
      videos = videos["videos"]["video"]
    end
    
    Video.where(:thumbnail => nil).each do |video|
      puts "Updating video #{video.title} (#{video.vimeo_code})"
      video.save if video.download_details
      success = video.save
    end
  end

  def download_details
    if video_url.match /vimeo/
      download_details_from_vimeo
    elsif video_url.match(/youtube/) || video_url.match(/youtu\.be/)
      download_details_from_youtube
    end
    true
  end

  private

  def download_details_from_youtube
    client = YouTubeIt::Client.new
    video = client.video_by(video_url)

    self.title = video.title
    self.description = video.description
    self.duration = video.duration
    self.video_url = "http://www.youtube.com/embed/#{video.unique_id}"

    self.image = nil
    self.thumbnail = nil
    video.thumbnails.each do |t|
      self.image = t.url if image.blank? && t.width > 400
      self.thumbnail = t.url if thumbnail.blank? && t.width > 100 && t.width < 300
    end
  end

  def download_details_from_vimeo
    info = Video.vimeo_video.get_info(video_url.match(/[0-9]{8}/)[0].to_i)
    return false unless info["video"]
    info = info["video"][0]
    self.duration = info["duration"]
    self.title = info["title"]
    self.description = info["description"]
    info["thumbnails"]['thumbnail'].each do |t|
      width = t["width"].to_i
      self.image = t["_content"] if width > 400
      self.thumbnail = t["_content"] if width > 100 && width < 300
    end
  end  
end