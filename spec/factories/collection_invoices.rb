# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :collection_invoice do
    number "MyString"
    amount "9.99"
    unit "MyString"
    invoice_type_id 1
    sent_at "2013-11-25 08:37:11"
    collection nil
    space nil
    client nil
    agency nil
  end
end
