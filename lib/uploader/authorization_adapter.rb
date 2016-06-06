module Uploader
  class AuthorizationAdapter
    attr_reader :user

    # Initialize a new authorization adapter. This happens on each and
    # every request to a controller.
    def initialize(user)
      @user = user
    end

    # Returns true of false depending on if the user is authorized to perform
    # the action on the subject.
    def authorized?(action, subject = nil)
      true
    end

    # A hook method for authorization libraries to scope the collection. By
    # default, we just return the same collection. The returned scope is used
    # as the starting point for all queries to the db in the controller.
    def scope_collection(collection, action = :index)
      collection
    end
  end
end
