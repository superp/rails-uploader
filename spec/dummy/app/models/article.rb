class Article < ActiveRecord::Base
  attr_accessible :content, :title
  
  has_one :picture, :as => :assetable, :dependent => :destroy

  fileuploads :picture
end
