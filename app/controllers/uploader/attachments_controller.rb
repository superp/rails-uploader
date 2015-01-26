module Uploader
  class AttachmentsController < ActionController::Metal
    include AbstractController::Callbacks
  
    before_filter :find_klass
    before_filter :find_asset, :only => [:destroy]
    
    def create
      @asset = @klass.new(params[:asset])
      @asset.uploader_create(params, request)
      render_resourse(@asset, 201)
    end
    
    def update
      @assets = Array.wrap(params[:assets] || [])

      @assets.each_with_index do |id, index|
        @klass.where(:id => id).update_all(:sort_order => index)
      end

      render_json(:files => [])
    end

    def destroy
      @asset.uploader_destroy(params, request)
      render_resourse(@asset, 200)
    end
    
    protected
    
      def find_klass
        @klass = Uploader.constantize(params[:klass])
        raise ActionController::RoutingError.new("Class not found #{params[:klass]}") if @klass.nil?
      end

      def find_asset
        @asset = @klass.where(:public_token => params[:id]).first
        raise ActionController::RoutingError.new("Asset not found by guid #{params[:id]}") if @asset.nil? 
      end
      
      def render_resourse(record, status = 200)
        if record.errors.empty?
          render_json({:files => [record]}, status)
        else
          render_json(record.errors, 422)
        end
      end
      
      def render_json(hash_or_object, status = 200)
        self.status = status
        self.content_type = Uploader.content_type(env["HTTP_USER_AGENT"])
        self.response_body = hash_or_object.to_json(:root => false)
      end
      
  end
end
