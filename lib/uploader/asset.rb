module Uploader
  module Asset
    def self.included(base)
      base.send(:include, Uploader::Asset::AssetProcessor)
    end

    module Mongoid
      def self.included(base)
        base.send(:include, Uploader::Asset::AssetProcessor)

        base.instance_eval do
          field :guid, type: String
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

      def assetable_id_format(assetable_id)
        Moped::BSON::ObjectId.from_string(assetable_id)
      end

      class << self
        def include_root_in_json
          false
        end
      end
    end

    module AssetProcessor
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
        begin
          self.guid = params[:guid]
          self.assetable_type = params[:assetable_type]
          self.assetable_id = assetable_id_format(params[:assetable_id])
          save
        rescue => e
          p e

          raise e
        end
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

    def assetable_id_format(assetable_id)
      assetable_id
    end
  end
end
