require 'rails'

module Uploader
  # Usage (config/routes.rb):
  #
  #   Rails.application.routes.draw do
  #     mount Uploader::Engine => '/uploader'
  #   end
  #
  class Engine < ::Rails::Engine
    isolate_namespace Uploader

    initializer 'uploader.assets_precompile' do |app|
      app.config.assets.precompile += Uploader.assets
    end

    initializer 'uploader.helpers' do
      ActiveSupport.on_load :action_view do
        ActionView::Base.send(:include, Uploader::Helpers::FormTagHelper)
        ActionView::Helpers::FormBuilder.send(:include, Uploader::Helpers::FormBuilder)
      end
    end

    initializer 'uploader.hooks' do
      require 'uploader/hooks/active_record' if Object.const_defined?('ActiveRecord')
      require 'uploader/hooks/simple_form'   if Object.const_defined?('SimpleForm')
      require 'uploader/hooks/formtastic'    if Object.const_defined?('Formtastic')
    end
  end
end
