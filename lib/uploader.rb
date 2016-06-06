# encoding: utf-8
require 'securerandom'
require 'uploader/version'

# Main uploader module
module Uploader
  autoload :Fileuploads, 'uploader/fileuploads'
  autoload :Asset, 'uploader/asset'

  # Just Rails helpers
  module Helpers
    autoload :FormTagHelper, 'uploader/helpers/form_tag_helper'
    autoload :FormBuilder, 'uploader/helpers/form_builder'
    autoload :FieldTag, 'uploader/helpers/field_tag'
  end

  # Column name to store unique fileupload guid
  mattr_accessor :guid_column
  @@guid_column = :guid

  def self.guid
    SecureRandom.base64(16).tr('+/=', 'xyz').slice(0, 20)
  end

  def self.root_path
    @root_path ||= Pathname.new(File.dirname(File.expand_path('../', __FILE__)))
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
end

require 'uploader/engine'
