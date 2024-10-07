class Article < ApplicationRecord
  has_one :picture, as: :assetable, dependent: :destroy

  fileuploads :picture
end
