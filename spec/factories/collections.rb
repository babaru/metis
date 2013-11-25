# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :collection do
    client nil
    project nil
    amount "9.99"
    unit "MyString"
    agency nil
    made_at "2013-11-25 08:36:58"
    credit_on "2013-11-25 08:36:58"
    space nil
  end
end
