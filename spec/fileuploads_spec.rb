# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Uploader::Fileuploads do
  let(:picture) { create(:picture, assetable_type: 'Article') }

  it 'should be a Module' do
    # raise FactoryBot.find_definitions.inspect
    require "/Users/mario/www/gems/rails-uploader/spec/factories/factories.rb"
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
      expect(asset).to eq picture
    end

    it 'should generate guid' do
      expect(article.fileupload_guid).not_to be_blank
    end

    it 'should change guid' do
      article.fileupload_guid = 'other guid'
      expect(article.fileupload_changed?).to be_truthy
      expect(article.fileupload_guid).to eq 'other guid'
    end

    it 'should not multiplay upload' do
      expect(article.fileupload_multiple?('picture')).to be_falsey
    end

    it 'should find uploaded asset or build new record' do
      picture = article.fileupload_asset(:picture)
      expect(picture).not_to be_nil
      expect(picture).to be_new_record
    end

    it 'must get fileupload params' do
      expect(article.fileupload_params(:picture)).not_to be nil
    end
  end
end
