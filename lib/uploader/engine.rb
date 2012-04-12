require 'rails'
require 'sunrise-file-upload'

module Sunrise
  module FileUpload
    class Engine < ::Rails::Engine
      # Initialize Rack file upload
      config.app_middleware.use Sunrise::FileUpload::Manager, :paths => "/sunrise/fileupload"
      
      initializer "sunrise.fileupload.setup" do
        ActiveSupport.on_load :active_record do
          ::ActiveRecord::Base.send :include, Sunrise::FileUpload::ActiveRecord
        end
        
        ActiveSupport.on_load :action_view do
          ActionView::Base.send :include, Sunrise::FileUpload::ViewHelper
          ActionView::Helpers::FormBuilder.send :include, Sunrise::FileUpload::FormBuilder
        end
      end
    end
  end
end
