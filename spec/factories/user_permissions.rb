# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_permission do
    user nil
    permission nil
  end
end
