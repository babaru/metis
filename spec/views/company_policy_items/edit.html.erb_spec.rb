require 'spec_helper'

describe "company_policy_items/edit" do
  before(:each) do
    @company_policy_item = assign(:company_policy_item, stub_model(CompanyPolicyItem))
  end

  it "renders the edit company_policy_item form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", company_policy_item_path(@company_policy_item), "post" do
    end
  end
end
