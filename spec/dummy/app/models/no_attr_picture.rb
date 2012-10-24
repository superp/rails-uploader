class NoAttrPicture < Asset
  mount_uploader :data, PictureUploader, :mount_on => :data_file_name
end

