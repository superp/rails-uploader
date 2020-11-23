# frozen_string_literal: true

module Uploader
  module JsonRendering
    def render_json(hash_or_object, status = 200)
      self.status = status
      self.content_type = request.format
      self.response_body = hash_or_object.to_json(root: false)
    end
  end
end
