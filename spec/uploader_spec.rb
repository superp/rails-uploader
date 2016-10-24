require 'spec_helper'

describe Uploader do
  it "should be a Module" do
    Uploader.should be_a(Module)
  end

  it "should generate random string" do
    value = Uploader.guid
    value.should_not be_blank
    value.size.should == 22
  end

  it "should find all precompile assets" do
    Uploader.assets.should_not be_nil
    Uploader.assets.should include('uploader/jquery.fileupload.js')
  end
end
