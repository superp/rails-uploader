module Uploader
  module Helpers
    class FieldTag
      attr_reader :template, :object, :theme

      delegate :uploader, :to => :template      
      
      # Wrapper for render uploader field
      # Usage:
      #
      #   uploader = FieldTag.new(object_name, method_name, template, options)
      #   uploader.to_s
      #
      def initialize(object_name, method_name, template, options = {}) #:nodoc:
        options = { :object_name => object_name, :method_name => method_name }.merge(options)
        
        @template, @options = template, options.dup
        @theme = (@options.delete(:theme) || "default")
        @value = @options.delete(:value) if @options.key?(:value)
        @object = @template.instance_variable_get("@#{object_name}")
        
        @options[:object] ||= @object
        @options[:input_html] = input_html.merge(@options[:input_html] || {})
      end

      def to_s(locals = {}) #:nodoc:
        locals = { :field => self }.merge(locals)
        @template.render :partial => "uploader/#{@theme}/container", :locals => @options.merge(locals)
      end
      
      def id
        @id ||= @template.dom_id(@object, [method_name, 'uploader'].join('_'))
      end
      
      def method_name
        @options[:method_name]
      end
      
      def object_name
        @options[:object_name]
      end
      
      def multiple?
        @object.fileupload_multiple?(method_name)
      end
      
      def value
        @value ||= @object.fileupload_asset(method_name)
      end
      
      def attachments_path(options = {})
        options = {
          :guid => @object.fileupload_guid, 
          :assetable_type => @object.class.name,
          :klass => @object.class.fileupload_klass(method_name)
        }.merge(options)
        
        options[:assetable_id] = @object.id if @object.persisted?
        
        uploader.attachments_path(options)
      end
      
      def input_html
        {:"data-url" => attachments_path, :multiple => multiple?}
      end
    end
  end
end
