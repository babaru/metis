require 'spec_helper'

describe "company_policies/index" do
  before(:each) do
    assign(:company_policies, [
      stub_model(CompanyPolicy),
      stub_model(CompanyPolicy)
    ])
  end

  it "renders a list of company_policies" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
