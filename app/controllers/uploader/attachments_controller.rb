# encoding: utf-8
module Uploader
  class AttachmentsController < ActionController::Metal
    include AbstractController::Callbacks
  
    before_filter :find_klass
    
    def create
      @asset = @klass.new(params[:asset])
      @asset.uploader_create(params, request)
      render_resourse(@asset, 201)
    end
    
    def destroy
      @asset = @klass.find(params[:id])
      @asset.uploader_destroy(params, request)
      render_resourse(@asset, 200)
    end
    
    protected
    
      def find_klass
        @klass = params[:klass].blank? ? nil : params[:klass].safe_constantize
        raise ActiveRecord::RecordNotFound.new("Class not found #{params[:klass]}") if @klass.nil?
      end
      
      def render_resourse(record, status = 200)
        if record.errors.empty?
          render_json(record.to_json, status)
        else
          render_json(record.errors.to_json, 422)
        end
      end
      
      def render_json(body, status = 200)
        self.status = status
        self.content_type = "application/json"
        self.response_body = body
      end
  end
end
