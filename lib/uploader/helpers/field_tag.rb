module Uploader
  module Helpers
    class FieldTag
      def initialize(object_name, method_name, template, options = {}) #:nodoc:
        options = { :object_name => object_name, :method_name => method_name }.merge(options)
        
        @template, @options = template, options.dup
        @theme = (@options.delete(:theme) || "default")
        @object = @template.instance_variable_get("@#{object_name}")
        
        @options[:object] ||= @object
        @options[:input_html] = input_html.merge(@options[:input_html] || {})
      end

      def to_s(locals = {}) #:nodoc:
        @template.render :partial => "uploader/#{@theme}/container", :locals => @options.merge(locals)
      end
      
      def input_html
        {:"data-url" => "/uploader/attachments", :multiple => true}
      end
    end
  end
end
