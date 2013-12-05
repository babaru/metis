# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :company_policy do
    client nil
    medium nil
    framework "9.99"
    year 1
  end
end
