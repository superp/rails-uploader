module Uploader
  module Fileuploads
    def self.included(base)
      base.send :extend, SingletonMethods
    end

    module Mongoid
      def self.included(base)
        base.send :include, Uploader::Fileuploads
      end

      def self.include_root_in_json
        false
      end
    end

    module SingletonMethods
      # Join ActiveRecord object with uploaded file
      # Usage:
      # 
      #   class Article < ActiveRecord::Base
      #     has_one :picture, :as => :assetable, :dependent => :destroy
      #
      #     fileuploads :picture
      #   end
      #
      #
      def fileuploads(*args)
        options = args.extract_options!
        
        class_attribute :fileuploads_options, :instance_writer => false
        self.fileuploads_options = options
        
        class_attribute :fileuploads_columns, :instance_writer => false
        self.fileuploads_columns = args.map(&:to_sym)
        
        unless self.is_a?(ClassMethods)
          include InstanceMethods
          extend ClassMethods
          
          after_save :fileuploads_update, :if => :fileupload_changed?
          
          fileuploads_columns.each { |asset| accepts_nested_attributes_for asset, :allow_destroy => true }
        end
      end
    end
    
    module ClassMethods
      # Update reflection klass by guid
      def fileupload_update(record_id, guid, method)
        fileupload_scope(method, guid).update_all(:assetable_id => record_id, :guid => nil)
      end
      
      # Find asset(s) by guid
      def fileupload_find(method, guid)
        query = fileupload_scope(method, guid)
        fileupload_multiple?(method) ? query.all : query.first
      end

      def fileupload_scope(method, guid)
        fileupload_klass(method).where(:guid => guid, :assetable_type => base_class.name.to_s)
      end
      
      # Find class by reflection
      def fileupload_klass(method)
        reflect_on_association(method.to_sym).klass
      end

      def fileupload_multiple?(method)
        association = reflect_on_association(method.to_sym)

        # many? for Mongoid, :collection? for AR
        method_name = association.respond_to?(:many?) ? :many? : :collection?

        !!(association && association.send(method_name))
      end

      unless respond_to?(:base_class)
        def base_class
          self
        end
      end
    end
    
    module InstanceMethods
      # Generate unique key
      def fileupload_guid
        @fileupload_guid ||= Uploader.guid
      end
      
      def fileupload_guid=(value)
        @fileupload_changed = true unless value.blank?
        @fileupload_guid = value.blank? ? nil : value
      end
      
      def fileupload_changed?
        @fileupload_changed === true
      end
      
      def fileupload_multiple?(method)
        self.class.fileupload_multiple?(method)
      end
      
      # Find or build new asset object
      def fileupload_asset(method)
        if fileuploads_columns.include?(method.to_sym)
          asset = new_record? ? self.class.fileupload_find(method, fileupload_guid) : send(method)
          asset ||= send("build_#{method}") if respond_to?("build_#{method}")
          asset
        end
      end
      
      def fileuploads_columns
        self.class.fileuploads_columns
      end
      
      protected
      
        def fileuploads_update
          fileuploads_columns.each do |method|
            self.class.fileupload_update(id, fileupload_guid, method)
          end
        end
    end
  end
end
