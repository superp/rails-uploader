require 'active_support/concern'

module Uploader
  module Fileuploads
    extend ActiveSupport::Concern

    included do
      class_attribute :fileupload_options, instance_writer: false

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

      # Update reflection klass by guid
      def fileupload_update(record_id, guid, method)
        fileupload_scope(method, guid).update_all(assetable_id: record_id, Uploader.guid_column => nil)
      end

      # Find asset(s) by guid
      def fileupload_find(method, guid)
        query = fileupload_scope(method, guid)
        fileupload_multiple?(method) ? query : query.first
      end

      def fileupload_scope(method, guid)
        fileupload_klass(method).where(assetable_type: base_class.name.to_s, Uploader.guid_column => guid)
      end

      # Find class by reflection
      def fileupload_klass(method)
        reflect_on_association(method.to_sym).klass
      end

      def fileupload_multiple?(method)
        association = reflect_on_association(method.to_sym)

        # many? for Mongoid and :collection? for AR
        method_name = association.respond_to?(:many?) ? :many? : :collection?

        association && association.send(method_name)
      end
    end

    # Generate unique key per form
    def fileupload_guid
      @fileupload_guid ||= Uploader.guid
    end

    def fileupload_guid=(value)
      @fileupload_changed = (@fileupload_guid != value)
      @fileupload_guid = value.blank? ? nil : value
    end

    def fileupload_changed?
      @fileupload_changed == true
    end

    def fileupload_multiple?(method)
      self.class.fileupload_multiple?(method)
    end

    # Find or build new asset object
    def fileupload_asset(method)
      if fileupload_associations.include?(method.to_sym)
        asset = new_record? ? self.class.fileupload_find(method, fileupload_guid) : send(method)
        asset ||= send("build_#{method}") if respond_to?("build_#{method}")
        asset
      end
    end

    def fileupload_associations
      self.class.fileupload_options.keys
    end

    protected

    def fileupload_update
      fileupload_options.each do |method, _options|
        self.class.fileupload_update(id, fileupload_guid, method)
      end
    end
  end
end
