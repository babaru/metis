require 'spec_helper'

describe "company_policy_items/index" do
  before(:each) do
    assign(:company_policy_items, [
      stub_model(CompanyPolicyItem),
      stub_model(CompanyPolicyItem)
    ])
  end

  it "renders a list of company_policy_items" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
