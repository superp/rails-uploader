require 'active_support/concern'

module Uploader
  module Fileuploads
    extend ActiveSupport::Concern

    included do
      class_attribute :fileupload_options, instance_writer: false

      delegate :asset, :multiple?, :params, :klass, to: :fileupload_glue, prefix: :fileupload

      after_create :fileupload_update, if: :fileupload_changed?
    end

    module ClassMethods
      # Join ActiveRecord object with uploaded file
      # Usage:
      #
      #   class Article < ActiveRecord::Base
      #     has_one :picture, as: :assetable, dependent: :destroy
      #
      #     fileuploads :picture
      #   end
      #
      #
      def fileuploads(*args)
        options = args.extract_options!

        self.fileupload_options ||= {}

        args.each do |column|
          self.fileupload_options[column] = options
        end
      end
    end

    # Generate unique key per form
    def fileupload_guid
      @fileupload_guid ||= Uploader.guid
    end

    def fileupload_guid=(value)
      @fileupload_changed = (@fileupload_guid != value) if @fileupload_changed.nil?
      @fileupload_guid = value.blank? ? nil : value
    end

    def fileupload_changed?
      @fileupload_changed == true
    end

    protected

    def fileupload_glue
      @fileupload_glue ||= Uploader::FileuploadGlue.new(self)
    end

    def fileupload_update
      fileupload_glue.join!
    end
  end
end
