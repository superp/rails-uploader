require 'formtastic'

class UploaderInput
  include ::Formtastic::Inputs::Base
  
  def to_html
    input_wrapping do
      label_html <<
      builder.uploader_field(method, input_html_options)
    end
  end

  def input_html_options
    data = super
    data[:confirm_delete] = options[:confirm_delete]
    data[:confirm_message] = localized_string(method, method, :delete_confirmation) || I18n.t('uploader.confirm_delete')
    data
  end
end
