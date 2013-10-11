# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :medium, :class => 'Media' do
    name "MyString"
    url "MyString"
    logo ""
    attachment_access_token "MyString"
    type ""
    created_by nil
  end
end
