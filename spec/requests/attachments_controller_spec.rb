require 'spec_helper'

describe Uploader::AttachmentsController do
  include Rack::Test::Methods
  
  def app
    Dummy::Application
  end
  
  it "should create new asset" do
    post "/uploader/attachments?"
    
    last_response.body.should == ""
  end
end
