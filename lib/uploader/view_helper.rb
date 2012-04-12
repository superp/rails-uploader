module Sunrise
  module FileUpload
    module ViewHelper
      include ActionView::Helpers::JavaScriptHelper
      
      def fileupload_tag(object_name, method, options = {})
        object = options.delete(:object) if options.key?(:object)
        object ||= @template.instance_variable_get("@#{object_name}")  
        
        value = options.delete(:value) if options.key?(:value)
        value ||= object.fileupload_asset(method)
               
        element_guid = object.fileupload_guid
        element_id = dom_id(object, [method, element_guid].join('_'))
        
        script_options = (options.delete(:script) || {}).stringify_keys
        
        params = {
          :method => method, 
          :assetable_id => object.new_record? ? nil : object.id, 
          :assetable_type => object.class.name,
          :guid => element_guid
        }.merge(script_options.delete(:params) || {})
        
        script_options['action'] ||= '/sunrise/fileupload?' + Rack::Utils.build_query(params)
        script_options['allowedExtensions'] ||=  ['jpg', 'jpeg', 'png', 'gif']
        script_options['multiple'] ||= object.fileupload_multiple?(method)
        
        content_tag(:div, :class => 'fileupload', :id => element_id) do
          content_tag(:noscript) do
            fields_for object do |form|
              form.fields_for method, value do |f|
                f.file_field :data
              end
            end
          end + javascript_tag( fileupload_script(element_id, value, script_options) )
        end
      end
      
      protected
      
        def fileupload_script(element_id, value = nil, options = {})
          options = { 'element' => element_id }.merge(options)
          formatted_options = options.inspect.gsub('=>', ':')
          js = [ "new qq.FileUploaderInput(#{formatted_options});" ]
          
          if value 
            Array.wrap(value).each do |asset|
              next unless asset.persisted?
              js << "qq.FileUploader.instances['#{element_id}']._updatePreview(#{asset.to_json});"
            end
          end
          
          "$(document).ready(function(){ #{js.join} });"
        end
      
    end
  end
end
