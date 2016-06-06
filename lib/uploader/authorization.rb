require 'active_support/concern'

module Uploader
  module Authorization
    extend ActiveSupport::Concern

    included do
      include ActiveSupport::Rescuable

      rescue_from Uploader::AccessDenied, with: :dispatch_uploader_access_denied
    end

    protected

    # Authorize the action and subject. Available in the controller
    def authorized?(action, subject = nil)
      uploader_authorization.authorized?(action, subject)
    end

    # Authorize the action and subject. Available in the controller.
    # If the action is not allowd, it raises an Uploader::AccessDenied exception.
    def authorize!(action, subject = nil)
      return if authorized?(action, subject)
      raise Uploader::AccessDenied.new(current_uploader_user, action, subject)
    end

    # Retrieve or instantiate the authorization instance for this resource
    def uploader_authorization
      @uploader_authorization ||= uploader_authorization_adapter.new(current_uploader_user)
    end

    # Returns the class to be used as the authorization adapter
    def uploader_authorization_adapter
      adapter = Uploader.authorization_adapter

      if adapter.is_a? String
        ActiveSupport::Dependencies.constantize(adapter)
      else
        adapter
      end
    end

    def dispatch_uploader_access_denied(exception)
      render json: { message: exception.message }, status: 403
    end

    def current_uploader_user
      return if Uploader.current_user_proc.nil?
      @current_uploader_user ||= Uploader.current_user_proc.call(request)
    end
  end
end
