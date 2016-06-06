class Picture < Asset
  mount_uploader :data, PictureUploader, mount_on: :data_file_name

  delegate :url, to: :data

  def thumb_url
    url(:thumb)
  end
end
