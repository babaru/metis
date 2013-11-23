# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :payment_invoice do
    number "MyString"
    amount "9.99"
    unit "MyString"
    invoice_type_id 1
    received_at "2013-11-23 13:44:29"
    payment nil
  end
end
