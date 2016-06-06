require 'spec_helper'

describe Uploader::AttachmentsController do
  include Rack::Test::Methods

  def app
    Dummy::Application
  end

  it "should create new asset" do
    file = Rack::Test::UploadedFile.new('spec/factories/files/rails.png', "image/png")
    post "/uploader/attachments", {
      :klass => "Picture",
      :assetable_id => "1",
      :assetable_type => "Article",
      :guid => "SOMESTRING",
      :asset => {:data => file}
    }

    last_response.body.should include('thumb_url')
    last_response.body.should include('name')
  end

  it "should destroy asset" do
    @asset = FactoryGirl.create(:picture)

    lambda {
      delete "/uploader/attachments/#{@asset.id}", {:klass => "Picture"}
    }.should change { Picture.count }.by(-1)
  end

  it "should not destroy asset with not exists guid" do
    @asset = FactoryGirl.create(:picture)

    lambda {
      delete "/uploader/attachments/wrong", {:klass => "Picture"}
    }.should raise_error(ActionController::RoutingError)
  end

  it "should raise 404 error with wrong class" do
    lambda {
      post "/uploader/attachments", {:klass => "wrong"}
    }.should raise_error(ActionController::RoutingError)
  end
end
