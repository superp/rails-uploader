class Picture < Asset
  mount_uploader :data, PictureUploader
end
