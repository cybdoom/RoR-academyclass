class Event < ActiveRecord::Base
  belongs_to :location
  has_attached_file :event_image
end
