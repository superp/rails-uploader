module Sunrise
  module FileUpload
    class Manager
      extend Sunrise::FileUpload::Callbacks
      
      def initialize(app, options = {})
        @app = app
        @paths = [options[:paths]].flatten
      end
      
      def call(env)
        raw_file_post?(env) ? create(env) : @app.call(env)
      end
      
      # :api: private
      def _run_callbacks(*args) #:nodoc:
        self.class._run_callbacks(*args)
      end

      protected
      
        def create(env)
          request = Request.new(env)
          params = request.params.symbolize_keys
          
          asset = find_or_build_asset(params)
        	asset.assetable_type = params[:assetable_type]
		      asset.assetable_id = (params[:assetable_id] || 0).to_i
		      asset.guid = params[:guid]
        	asset.data = Http.normalize_param(params[:qqfile], request)
          
          _run_callbacks(:before_create, env, asset)
          
          if asset.save
            body = asset.to_json
            status = 200
            
            _run_callbacks(:after_create, env, asset)
          else
            body = asset.errors.to_json
            status = 422
          end
          
          [status, {'Content-Type' => 'text/html', 'Content-Length' => body.size.to_s}, body]
        end
        
        def find_or_build_asset(params)
          assetable = load_klass(params[:assetable_type])
          attribute_name = params[:method].to_s.downcase.to_sym
          reflection = assetable.reflect_on_association(attribute_name)
          klass = load_klass(reflection.class_name)
          
          asset = nil
          asset = find_asset(klass, params) unless reflection.collection?
          asset || klass.new(params[:asset])
        end
        
        def load_klass(class_name)
          return nil if class_name.blank?
          class_name.to_s.classify.constantize
        end
        
        def find_asset(klass, params)
          query = klass.scoped.where(:assetable_type => params[:assetable_type])
          
          if !params[:assetable_id].blank?
            query = query.where(:assetable_id => params[:assetable_id].to_i)
          elsif !params[:guid]
            query = query.where(:guid => params[:guid])
          else
            query = query.where(:id => params[:id])
          end
          
          query.first
        end
        
        def raw_file_post?(env)
          env['REQUEST_METHOD'] == 'POST' && upload_path?(env['PATH_INFO'])
        end
        
        def upload_path?(request_path)
          return true if @paths.nil?
          @paths.any? { |candidate| candidate == request_path  }
        end
    end
  end
end
