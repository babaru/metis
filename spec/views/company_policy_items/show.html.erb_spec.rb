require 'spec_helper'

describe "company_policy_items/show" do
  before(:each) do
    @company_policy_item = assign(:company_policy_item, stub_model(CompanyPolicyItem))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
