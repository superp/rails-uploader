module Uploader
  class FileuploadGlue
    attr_reader :record, :record_klass

    delegate :reflect_on_association, to: :record_klass
    delegate :fileupload_guid, :new_record?, to: :record

    DEFAULT_TARGET = 'assetable'.freeze
    TARGET_TYPE = '_type'.freeze
    TARGET_ID = '_id'.freeze

    def initialize(record)
      @record = record
      @record_klass = record.class

      @associations = {}
    end

    def join!
      available_fileuploads.each do |method_name|
        column_name = target_name(method_name).to_s + TARGET_ID
        scope_by_fileupload_guid(method_name, fileupload_guid).update_all(column_name => @record.id,
                                                                          Uploader.guid_column => nil)
      end
    end

    def params(method_name)
      {
        guid: fileupload_guid,
        assetable_type: record_klass_type,
        assetable_id: @record.id,
        klass: klass(method_name)
      }
    end

    def asset(method_name)
      return unless available_fileuploads.include?(method_name.to_sym)

      find_asset_by_fileupload_guid(method_name, fileupload_guid) || build_asset(method_name)
    end

    def association(method_name)
      name = method_name.to_sym
      @associations[name] ||= reflect_on_association(name)
    end

    # Find class by reflection
    def klass(method_name)
      return if association(method_name).nil?
      association(method_name).klass
    end

    # many? for Mongoid and collection? for AR
    def multiple?(method_name)
      return false if association(method_name).nil?

      name = association(method_name).respond_to?(:many?) ? :many? : :collection?
      association(method_name).send(name)
    end

    protected

    def available_fileuploads
      @available_fileuploads ||= @record_klass.fileupload_options.keys
    end

    def target_name(method_name)
      @record_klass.fileupload_options[method_name.to_sym].fetch(:target, DEFAULT_TARGET)
    end

    def build_asset(method_name)
      send("build_#{method_name}") if respond_to?("build_#{method_name}")
    end

    def find_asset_by_fileupload_guid(method_name, guid)
      if new_record?
        query = scope_by_fileupload_guid(method_name, guid)
        multiple?(method_name) ? query : query.first
      else
        @record.send(method_name)
      end
    end

    def scope_by_fileupload_guid(method_name, guid)
      column_name = target_name(method_name).to_s + TARGET_TYPE
      klass(method_name).where(column_name => record_klass_type.to_s, Uploader.guid_column => guid)
    end

    def record_klass_type
      if @record_klass.respond_to?(:base_class)
        @record_klass.base_class.name
      else
        @record_klass.name
      end
    end
  end
end
