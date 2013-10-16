# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :spot_category, :class => 'SpotCategory' do
    name "MyString"
    medium nil
  end
end
