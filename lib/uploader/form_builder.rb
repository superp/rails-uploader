module Sunrise
  module FileUpload
    module FormBuilder
      def self.included(base)
        base.send(:include, ClassMethods)
      end
      
      module ClassMethods
        # Example:
		    # <%= form_for @post do |form| %>
		    #   ...
		    #   <%= form.fileupload :picture %>
		    # <% end %>
		    #
		    def fileupload(method, options = {})
		      @template.fileupload_tag(@object_name, method, objectify_options(options))
        end
      end
    end
  end
end
