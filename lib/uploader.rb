# encoding: utf-8
require 'securerandom'

module Uploader
  autoload :Fileuploads, 'uploader/fileuploads'
  autoload :Asset, 'uploader/asset'
  autoload :AssetInstance, 'uploader/asset_instance'
  
  module Helpers
    autoload :FormTagHelper, 'uploader/helpers/form_tag_helper'
    autoload :FormBuilder, 'uploader/helpers/form_builder'
    autoload :FieldTag, 'uploader/helpers/field_tag'
  end

  def self.guid
    SecureRandom.base64(16).tr('+/=', 'xyz').slice(0, 20)
  end
  
  def self.root_path
    @root_path ||= Pathname.new( File.dirname(File.expand_path('../', __FILE__)) )
  end
  
  def self.assets
    Dir[root_path.join('vendor/assets/**/uploader/**', '*.{js,css,png,gif}')].inject([]) do |list, path|
      folder = path.split('/assets/')[1].split('/')[0]
      list << Pathname.new(path).relative_path_from(root_path.join("vendor/assets/#{folder}")).to_s
      list
    end
  end

  def self.constantize(klass)
    return if klass.blank?
    klass.safe_constantize
  end

  def self.content_type(user_agent)
    return "application/json" if user_agent.blank?

    ie_version = user_agent.scan(/(MSIE\s|rv:)([\d\.]+)/).flatten.last
    
    if user_agent.include?("Android") || (ie_version && ie_version.to_f <= 9.0) || (user_agent =~ /Trident\/[0-9\.]+\;/i)
      "text/plain"
    else
      "application/json"
    end
  end

end

require 'uploader/engine'
