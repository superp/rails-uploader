require 'active_record'

ActiveSupport.on_load :active_record do
  ActiveRecord::Base.send :include, Uploader::Fileuploads
end
