class Picture < Asset
  mount_uploader :data, PictureUploader, :mount_on => :data_file_name
  
  attr_accessible :data
end
