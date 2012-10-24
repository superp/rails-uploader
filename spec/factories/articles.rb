# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :article do
    title "MyString"
    content "MyText"
  end
end

FactoryGirl.define do
  factory :no_attr_article do
    title "MyString"
    content "MyText"
  end
end
