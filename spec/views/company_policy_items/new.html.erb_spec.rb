require 'spec_helper'

describe "company_policy_items/new" do
  before(:each) do
    assign(:company_policy_item, stub_model(CompanyPolicyItem).as_new_record)
  end

  it "renders new company_policy_item form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", company_policy_items_path, "post" do
    end
  end
end
