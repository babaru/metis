require 'spec_helper'

describe "company_policies/show" do
  before(:each) do
    @company_policy = assign(:company_policy, stub_model(CompanyPolicy))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
