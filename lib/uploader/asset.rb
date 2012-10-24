module Uploader
  module Asset
    module Mongoid
      def self.included(klass)
        klass.send(:include, Uploader::Asset)

        klass.instance_eval do
          field :guid, type: String
          field :assetable_type, type: String
          field :assetable_id, type: String
        end
      end

      def as_json(options = {})
        json_data = super
        json_data['filename'] = File.basename(data.path)
        json_data['size'] = data.file.size
        json_data['id'] = json_data['_id']

        if data.respond_to?(:thumb)
          json_data['thumb_url'] = data.thumb.url
        end

        json_data
      end

      class << self
        def include_root_in_json
          false
        end
      end
    end

    # Save asset
    # Usage:
    #
    #   class Asset < ActiveRecord::Base
    #     include Uploader::Asset
    #     
    #     def uploader_create(params, request = nil)
    #       self.user = request.env['warden'].user
    #       super
    #     end
    #   end
    #
    def uploader_create(params, request = nil)
      self.guid = params[:guid]
      self.assetable_type = params[:assetable_type]
      self.assetable_id = params[:assetable_id]
      save
    end
    
    # Destroy asset
    # Usage (cancan example):
    #
    #   class Asset < ActiveRecord::Base
    #     include Uploader::Asset
    #     
    #     def uploader_destroy(params, request = nil)
    #       ability = Ability.new(request.env['warden'].user)
    #       if ability.can? :delete, self
    #         super
    #       else
    #         errors.add(:id, :access_denied)
    #       end
    #     end
    #   end
    #
    def uploader_destroy(params, request)
      destroy
    end
  end
end
