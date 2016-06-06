# == Schema Information
#
# Table name: assets
#
#  id                :integer(4)      not null, primary key
#  data_file_name    :string(255)     not null
#  data_content_type :string(255)
#  data_file_size    :integer(4)
#  assetable_id      :integer(4)      not null
#  assetable_type    :string(25)      not null
#  type              :string(25)
#  guid              :string(10)
#  user_id           :integer(4)
#  sort_order        :integer(4)      default(0)
#  created_at        :datetime
#  updated_at        :datetime
#
# Indexes
#
#  index_assets_on_assetable_type_and_assetable_id           (assetable_type,assetable_id)
#  index_assets_on_user_id                                   (user_id)
#
class Asset < ActiveRecord::Base
  include Uploader::Asset

  belongs_to :assetable, polymorphic: true

  def filename
    data_file_name
  end

  def content_type
    data_content_type
  end

  def size
    data_file_size
  end
end
