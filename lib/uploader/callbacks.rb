# encoding: utf-8
module Sunrise
  module FileUpload
    module Callbacks
      # Hook to _run_callbacks asserting for conditions.
      def _run_callbacks(kind, *args) #:nodoc:
        options = args.last # Last callback arg MUST be a Hash

        send("_#{kind}").each do |callback, conditions|
          invalid = conditions.find do |key, value|
            value.is_a?(Array) ? !value.include?(options[key]) : (value != options[key])
          end

          callback.call(*args) unless invalid
        end
      end
      
      # A callback that runs before create asset
      # Example:
      #   Sunrise::FileUpload::Manager.before_create do |env, opts|
      #   end
      #
      def before_create(options = {}, method = :push, &block)
        raise BlockNotGiven unless block_given?
        _before_create.send(method, [block, options])
      end
      
      # Provides access to the callback array for before_create
      # :api: private
      def _before_create
        @_before_create ||= []
      end
      
      # A callback that runs after asset created
      # Example:
      #   Sunrise::FileUpload::Manager.after_create do |env, opts|
      #   end
      #
      def after_create(options = {}, method = :push, &block)
        raise BlockNotGiven unless block_given?
        _after_create.send(method, [block, options])
      end
      
      # Provides access to the callback array for after_create
      # :api: private
      def _after_create
        @_after_create ||= []
      end
    end
  end
end
