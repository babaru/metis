# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :payment do
    client nil
    project nil
    value "9.99"
    unit "MyString"
    medium nil
    vendor nil
    paid_at "2013-11-23 13:31:14"
    credit_on "2013-11-23 13:31:14"
  end
end
