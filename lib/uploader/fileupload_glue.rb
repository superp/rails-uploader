module Uploader
  class FileuploadGlue
    attr_reader :record, :record_klass

    delegate :reflect_on_association, to: :record_klass
    delegate :fileupload_guid, :new_record?, to: :record

    TARGET_TYPE = '_type'.freeze
    TARGET_ID = '_id'.freeze

    def initialize(record)
      @record = record
      @record_klass = record.class

      @associations = {}
    end

    def join!
      available_fileuploads.each do |method_name|
        target_name = target_column_name(method_name).to_s + TARGET_ID
        guid_name = guid_column_name(method_name)

        scope_by_fileupload_guid(method_name, fileupload_guid).update_all(target_name => @record.id,
                                                                          guid_name => nil)
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
      return [] if @record_klass.fileupload_options.nil?
      @available_fileuploads ||= @record_klass.fileupload_options.keys
    end

    def target_column_name(method_name)
      @record_klass.fileupload_options[method_name.to_sym].fetch(:assetable, Uploader.assetable_column)
    end

    def guid_column_name(method_name)
      @record_klass.fileupload_options[method_name.to_sym].fetch(:guid, Uploader.guid_column)
    end

    def build_asset(method_name)
      build_method = "build_#{method_name}"
      return unless @record.respond_to?(build_method)

      @record.send(build_method)
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
      target_name = target_column_name(method_name).to_s + TARGET_TYPE
      guid_name = guid_column_name(method_name)

      klass(method_name).where(target_name => record_klass_type.to_s, guid_name => guid)
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
