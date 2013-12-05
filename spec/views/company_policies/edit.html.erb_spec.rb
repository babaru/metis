require 'spec_helper'

describe "company_policies/edit" do
  before(:each) do
    @company_policy = assign(:company_policy, stub_model(CompanyPolicy))
  end

  it "renders the edit company_policy form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", company_policy_path(@company_policy), "post" do
    end
  end
end
