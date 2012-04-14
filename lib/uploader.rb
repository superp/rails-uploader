# encoding: utf-8
require 'securerandom'

module Uploader
  module Helpers
    autoload :FormTagHelper, 'uploader/helpers/form_tag_helper'
    autoload :FormBuilder, 'uploader/helpers/form_builder'
    autoload :FieldTag, 'uploader/helpers/field_tag'
  end
  
  def self.guid
    SecureRandom.base64(15).tr('+/=', 'xyz').slice(0, 10)
  end
  
  def self.root_path
    @root_path ||= Pathname.new( File.dirname(File.expand_path('../', __FILE__)) )
  end
  
  def self.assets
    Dir[root_path.join('vendor/assets/javascripts/uploader/**', '*.{js,css}')].inject([]) do |list, path|
      list << Pathname.new(path).relative_path_from(root_path.join('vendor/assets/javascripts'))
      list
    end
  end
end

require 'uploader/engine'
