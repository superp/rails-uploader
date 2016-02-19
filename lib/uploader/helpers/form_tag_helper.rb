module Uploader
  module Helpers
    module FormTagHelper
      include ActionView::Helpers::JavaScriptHelper

      # A helper that renders file upload container
      #
      #   <%= uploader_field_tag :article, :photo %>
      #
      def uploader_field_tag(object_name, method_name, options = {})
        FieldTag.new(object_name, method_name, self, options).render
      end
    end
  end
end
