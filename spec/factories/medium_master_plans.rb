# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :medium_master_plan do
    master_plan nil
    medium nil
    medium_net_cost "9.99"
    company_net_cost "9.99"
  end
end
