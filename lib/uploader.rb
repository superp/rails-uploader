require 'securerandom'

module Uploader
  autoload :Http, 'uploader/http'
  autoload :Manager, 'uploader/manager'
  autoload :Request, 'uploader/request'
  autoload :ActiveRecord, 'uploader/active_record'
  autoload :Callbacks, 'uploader/callbacks'
  
  autoload :ViewHelper, 'uploader/view_helper'
  autoload :FormBuilder, 'uploader/form_builder'
  
  def self.guid
    SecureRandom.base64(15).tr('+/=', 'xyz').slice(0, 10)
  end
end

require 'uploader/engine'
