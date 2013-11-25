# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :permission_group_permission do
    permission_group nil
    permission nil
  end
end
