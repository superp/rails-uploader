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
    
    last_response.body.should include("assetable_type")
    last_response.body.should include("SOMESTRING")
    last_response.body.should include("data")
  end
  
  it "should destroy asset" do
    @asset = FactoryGirl.create(:picture)
    
    lambda {
      delete "/uploader/attachments/#{@asset.id}", {:klass => "Picture"}
    }.should change { Picture.count }.by(-1)
  end
  
  it "should raise 404 error with wrong class" do
    lambda {
      post "/uploader/attachments", {:klass => "wrong"}
    }.should raise_error(ActionController::RoutingError)
  end

  it "should obey use_attr_accessible" do
    @no_attr_article = FactoryGirl.create(:no_attr_article)
    @title = 'title'

    @no_attr_article.update_attributes(:title => @title)
    @no_attr_article.title.should == @title
  end
end
