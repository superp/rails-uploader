class Article < ActiveRecord::Base
  has_one :picture, as: :assetable, dependent: :destroy

  fileuploads :picture
end
