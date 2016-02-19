module Uploader
  module Helpers
    module FormBuilder
      # Render uploader field
      # Usage:
      #
      #   <%= form_for @article do |f| %>
      #     <%= f.uploader_field :picture %>
      #   <%= end %>
      #
      def uploader_field(method, options = {})
        @template.send(:uploader_field_tag, @object_name, method, objectify_options(options))
      end
    end
  end
end
