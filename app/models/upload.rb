class Upload < ActiveRecord::Base
  MAX_FILE_SIZE = 3145728 # 3Mb
  MAX_FILE_COUNT = 50
  
  has_attached_file :file
  validates_presence_of :file_file_name, :file_file_size
  
  def validate
    return unless file.file?
    errors.add(:file, "too big (#{MAX_FILE_SIZE/1048576}Mb max)") if file_file_size > MAX_FILE_SIZE
    errors.add(:file, "too many (#{MAX_FILE_COUNT} files max)") if Upload.count > MAX_FILE_COUNT
  end
end
