require "simple_form"

class UploaderInput < ::SimpleForm::Inputs::Base
  def input
    @builder.uploader_field(attribute_name, input_html_options)
  end
end
