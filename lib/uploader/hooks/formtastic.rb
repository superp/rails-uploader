require 'formtastic'

module Formtastic
  module Inputs
    class UploaderInput
      include ::Formtastic::Inputs::Base

      def to_html
        input_wrapping do
          label_html << builder.uploader_field(method, input_html_options)
        end
      end
    end
  end
end
