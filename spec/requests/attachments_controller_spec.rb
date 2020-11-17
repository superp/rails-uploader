require 'spec_helper'

describe Uploader::AttachmentsController do
  include Rack::Test::Methods

  def app
    Dummy::Application
  end

  before :each do
    Picture.destroy_all
  end

  it "should create new asset" do
    file = Rack::Test::UploadedFile.new('spec/factories/files/rails.png', "image/png")
    article = FactoryGirl.create(:article)
    post "/uploader/attachments", {
      :klass => "Picture",
      :assetable_id => article.id,
      :assetable_type => article.class.name,
      :guid => "SOMESTRING",
      :asset => {:data => file}
    }

    Picture.count.should == 1

    last_response.body.should include('thumb_url')
    last_response.body.should include('name')
  end

  it "should destroy old asset on new asset for has_one" do
    file = Rack::Test::UploadedFile.new('spec/factories/files/rails.png', "image/png")
    article = FactoryGirl.create(:article)
    post "/uploader/attachments", {
      :klass => "Picture",
      :assetable_id => article.id,
      :assetable_type => article.class.name,
      :guid => "SOMESTRING",
      :singular => true,
      :asset => {:data => file}
    }

    Picture.count.should == 1

    post "/uploader/attachments", {
      :klass => "Picture",
      :assetable_id => article.id,
      :assetable_type => article.class.name,
      :guid => "SOMESTRING",
      :singular => true,
      :asset => {:data => file}
    }

    Picture.count.should == 1

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
    }.should raise_error(ActionController::ParameterMissing)
  end
end
