class NoAttrArticle < ActiveRecord::Base
  attr_protected nil

  has_one :no_attr_picture, :as => :assetable, :dependent => :destroy

  fileuploads :no_attr_picture, :use_attr_accessible => false
end

