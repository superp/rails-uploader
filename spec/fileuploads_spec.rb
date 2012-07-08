require 'spec_helper'

describe Uploader::Fileuploads do
  before(:all) do
    @picture = FactoryGirl.create(:picture)
  end

  it "should be a Module" do
    Uploader::Fileuploads.should be_a(Module)
  end
  
  it "should return asset class" do
    Article.fileupload_klass("picture").should == Picture
  end
  
  it "should find asset by guid" do
    asset = Article.fileupload_find("picture", @picture.guid)
    asset.should == @picture
  end

  it "should update asset target_id by guid" do
    Article.fileupload_update(1000, @picture.guid, :picture)
    @picture.reload
    @picture.assetable_id.should == 1000
    @picture.guid.should be_nil
  end

  context "instance methods" do
    before(:each) do
      @article = FactoryGirl.build(:article)
    end

    it "should generate guid" do
      @article.fileupload_guid.should_not be_blank
    end

    it "should change guid" do
      @article.fileupload_guid = "other guid"
      @article.fileupload_changed?.should be_true
      @article.fileupload_guid.should == "other guid"
    end

    it "should not multiplay upload" do
      @article.fileupload_multiple?("picture").should be_false
    end

    it "should find uploaded asset or build new record" do
      picture = @article.fileupload_asset(:picture)
      picture.should_not be_nil
      picture.should be_new_record
    end

    it "should return fileuploads columns" do
      @article.fileuploads_columns.should include(:picture)
    end
  end
end