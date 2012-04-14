# encoding: utf-8
module Uploader
  class AttachmentsController < ActionController::Metal
    def create
      self.status = 201
      self.response_body = params.to_json
    end
    
    def destroy
      
    end
  end
end
