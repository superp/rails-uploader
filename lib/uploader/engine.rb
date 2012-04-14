require 'rails'
require 'uploader'

module Uploader
  class Engine < ::Rails::Engine
    isolate_namespace Uploader
    
    initializer "uploader.assets_precompile" do |app|
      app.config.assets.precompile += Uploader.assets
    end
    
    initializer "uploader.helpers" do    
      ActiveSupport.on_load :action_view do
        ActionView::Base.send(:include, Uploader::Helpers::FormTagHelper)
        ActionView::Helpers::FormBuilder.send(:include, Uploader::Helpers::FormBuilder)
      end
    end  
  end
end
