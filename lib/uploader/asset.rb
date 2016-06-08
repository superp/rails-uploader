require 'active_support/concern'

module Uploader
  module Asset
    extend ActiveSupport::Concern

    module ClassMethods
      def fileupload_find_asset(params)
        where(id: params[:id]).first
      end

      def fileupload_find_assets(params)
        where(assetable_type: params[:assetable_type], assetable_id: params[:assetable_id])
      end

      def fileupload_update_ordering(params)
        assets = Array.wrap(params[:assets] || [])

        assets.each_with_index do |id, index|
          where(id: id).update_all(sort_order: index)
        end
      end
    end

    # Save asset
    # Usage:
    #
    #   class Asset < ActiveRecord::Base
    #     include Uploader::Asset
    #
    #     def fileupload_create(params, request = nil)
    #       self.user = request.env['warden'].user
    #       super
    #     end
    #   end
    #
    def fileupload_create(params, _request = nil)
      self[Uploader.guid_column] = params[:guid]
      fileupload_set_assetable(params)
      save
    end

    # Destroy asset
    # Usage (cancan example):
    #
    #   class Asset < ActiveRecord::Base
    #     include Uploader::Asset
    #
    #     def fileupload_destroy(params, request = nil)
    #       ability = Ability.new(request.env['warden'].user)
    #       if ability.can? :delete, self
    #         super
    #       else
    #         errors.add(:id, :access_denied)
    #       end
    #     end
    #   end
    #
    def fileupload_destroy(_params, _request = nil)
      destroy
    end

    # Serialize asset to fileupload JSON format
    #
    def to_fileupload
      {
        id: id,
        name: filename,
        content_type: content_type,
        size: size,
        url:  url,
        thumb_url: thumb_url
      }
    end

    protected

    def fileupload_set_assetable(params)
      self.assetable_type = params[:assetable_type]
      self.assetable_id = params[:assetable_id]
    end
  end
end
