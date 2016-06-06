module Uploader
  class AttachmentsController < ActionController::Metal
    include AbstractController::Callbacks

    before_action :find_klass
    before_action :find_asset, only: [:destroy]

    def index
      @assets = @klass.fileupload_find_assets(params)
      render_json(files: @assets.map(&:to_fileupload))
    end

    def create
      @asset = @klass.new(asset_params)
      @asset.fileupload_create(params, request)
      render_resourse(@asset, 201)
    end

    def update
      @klass.fileupload_update_ordering(params)
      render_json(files: [])
    end

    def destroy
      @asset.fileupload_destroy(params, request)
      render_resourse(@asset)
    end

    protected

    def find_klass
      @klass = Uploader.constantize(params[:klass])
      raise ActionController::RoutingError, "Class not found #{params[:klass]}" if @klass.nil?
    end

    def find_asset
      @asset = @klass.fileupload_find_asset(params)
      raise ActionController::RoutingError, "Asset not found by #{params[:id]}" if @asset.nil?
    end

    def render_resourse(record, status = 200)
      if record.errors.empty?
        render_json({ files: [record.to_fileupload] }, status)
      else
        hash = { name: record.filename, error: record.errors.full_messages.first }
        render_json({ files: [hash] }, 422)
      end
    end

    def render_json(hash_or_object, status = 200)
      self.status = status
      self.content_type = request.format
      self.response_body = hash_or_object.to_json(root: false)
    end

    def asset_params
      ActionController::Parameters.new(params).require(:asset).permit(:data)
    end
  end
end
