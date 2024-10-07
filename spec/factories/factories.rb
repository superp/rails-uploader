# frozen_string_literal: true

FactoryBot.define do
  raise Article.inspect

  factory :article, class: Article do
    title { 'MyString' }
    content { 'MyText' }
  end

  factory :picture, class: Picture do
    data { File.open('spec/factories/files/rails.png') }
    data_content_type { 'image/png' }
    data_file_name { 'rails.png' }

    association :assetable, factory: :article
  end
end
