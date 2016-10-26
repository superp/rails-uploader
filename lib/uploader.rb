# encoding: utf-8
require 'securerandom'
require 'uploader/version'

# Main uploader module
module Uploader
  autoload :Fileuploads, 'uploader/fileuploads'
  autoload :Asset, 'uploader/asset'
  autoload :Authorization, 'uploader/authorization'
  autoload :AuthorizationAdapter, 'uploader/authorization_adapter'
  autoload :ChunkedUploads, 'uploader/chunked_uploads'
  autoload :UploadRequest, 'uploader/upload_request'
  autoload :FilePart, 'uploader/file_part'
  autoload :FileuploadGlue, 'uploader/fileupload_glue'

  # Just Rails helpers
  module Helpers
    autoload :FormTagHelper, 'uploader/helpers/form_tag_helper'
    autoload :FormBuilder, 'uploader/helpers/form_builder'
    autoload :FieldTag, 'uploader/helpers/field_tag'
  end

  # Column name to store unique fileupload guid
  mattr_accessor :guid_column
  @@guid_column = :guid

  # Column name to store target record
  mattr_accessor :assetable_column
  @@assetable_column = :assetable

  # The authorization adapter to use
  mattr_accessor :authorization_adapter
  @@authorization_adapter = Uploader::AuthorizationAdapter

  mattr_accessor :current_user_proc
  @@current_user_proc = nil

  # Default way to setup Uploader
  #
  #   Uploader.setup do |config|
  #     config.authorization_adapter = CanCanUploaderAdapter
  #     config.current_user_proc = -> (request) { request.env['warden'].user(:admin_user) }
  #   end
  #
  def self.setup
    yield self
  end

  def self.guid
    SecureRandom.urlsafe_base64
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

  # Exception class to raise when there is an authorized access
  # exception thrown. The exception has a few goodies that may
  # be useful for capturing / recognizing security issues.
  class AccessDenied < StandardError
    attr_reader :user, :action, :subject

    def initialize(user, action, subject = nil)
      @user = user
      @action = action
      @subject = subject

      super(message)
    end

    def message
      I18n.t('uploader.access_denied.message')
    end
  end
end

require 'uploader/engine'
