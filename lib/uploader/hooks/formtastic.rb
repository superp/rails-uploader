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

      def input_html_options
        data = super
        data[:confirm_delete] = options[:confirm_delete]
        data[:confirm_message] = localized_confirm_message
        data
      end

      protected

      def localized_confirm_message
        localized_string(method, method, :delete_confirmation) || I18n.t('uploader.confirm_delete')
      end
    end
  end
end
