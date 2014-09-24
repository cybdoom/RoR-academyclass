class News < ActiveRecord::Base
  
  validates_presence_of :title, :description, :content

end
