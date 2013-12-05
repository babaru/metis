require 'spec_helper'

describe "company_policies/new" do
  before(:each) do
    assign(:company_policy, stub_model(CompanyPolicy).as_new_record)
  end

  it "renders new company_policy form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", company_policies_path, "post" do
    end
  end
end
