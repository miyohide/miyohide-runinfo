class Track < ActiveRecord::Base
  attr_accessible :name, :gpx
  has_attached_file :gpx
end
