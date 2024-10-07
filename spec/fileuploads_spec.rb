# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Uploader::Fileuploads do
  let(:picture) { create(:picture, assetable_type: 'Article') }

  it 'should be a Module' do
    expect(Uploader::Fileuploads).to be_a(Module)
  end

  context 'instance methods' do
    let(:article) { build(:article) }

    it 'should return asset class' do
      expect(article.fileupload_klass('picture')).to eq Picture
    end

    it 'should find asset by guid' do
      picture.update_column(:guid, article.fileupload_guid)

      asset = article.fileupload_asset('picture')
      asset.should == picture
    end

    it 'should generate guid' do
      article.fileupload_guid.should_not be_blank
    end

    it 'should change guid' do
      article.fileupload_guid = 'other guid'
      article.fileupload_changed?.should be_truthy
      article.fileupload_guid.should == 'other guid'
    end

    it 'should not multiplay upload' do
      article.fileupload_multiple?('picture').should be_falsey
    end

    it 'should find uploaded asset or build new record' do
      picture = article.fileupload_asset(:picture)
      picture.should_not be_nil
      picture.should be_new_record
    end

    it 'must get fileupload params' do
      article.fileupload_params(:picture).should_not be nil
    end
  end
end
