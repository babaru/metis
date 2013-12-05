# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :company_policy_item do
    min "9.99"
    max "9.99"
    rebate "9.99"
    remark "MyString"
  end
end
