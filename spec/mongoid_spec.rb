require 'spec_helper'
require 'mongoid'

Mongoid.load!('spec/mongoid.yml', ENV['RAILS_ENV'])

class MongoidArticle
  include Mongoid::Document
  include Uploader::Fileuploads

  has_one :mongoid_picture, as: :assetable

  fileuploads :mongoid_picture
end

class MongoidPicture
  include Mongoid::Document
  include Uploader::Asset

  field :guid, type: String

  belongs_to :assetable, polymorphic: true
end

describe Uploader::Asset do
  before do
    @guid = 'guid'
    @article = MongoidArticle.new(fileupload_guid: @guid)
    @picture = MongoidPicture.create!(guid: @guid, assetable_type: 'MongoidArticle')
  end

  it 'should find asset by guid' do
    asset = @article.fileupload_asset(:mongoid_picture)
    asset.should == @picture
  end

  it "should update asset target_id by guid" do
    @article.save

    @picture.reload
    @picture.assetable_id.should == @article.id
    @picture.guid.should be_nil
  end

  after do
    MongoidPicture.destroy_all
  end
end
