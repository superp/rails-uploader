# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :picture, class: Picture do
    data File.open('spec/factories/files/rails.png')
    data_content_type 'image/png'
    data_file_name 'rails.png'

    association :assetable, factory: :article
  end
end
