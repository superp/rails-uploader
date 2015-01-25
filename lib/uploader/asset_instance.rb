module Uploader
  module AssetInstance
    require 'protected_attributes'

    def self.included(base)
      base.send(:extend, Uploader::AssetInstance::ClassMethods)
      base.send(:include, Uploader::AssetInstance::InstanceMethods)
    end

    module ClassMethods
      
      def permit_attribute(attribute)
        attr_accessible attribute.to_sym
      end

    end

    module InstanceMethods

    end
  end
end