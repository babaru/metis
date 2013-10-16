require 'spec_helper'

describe "medium_policies/new" do
  before(:each) do
    assign(:medium_policy, stub_model(MediumPolicy).as_new_record)
  end

  # it "renders new medium_policy form" do
  #   render

  #   # Run the generator again with the --webrat flag if you want to use webrat matchers
  #   assert_select "form[action=?][method=?]", medium_policies_path, "post" do
  #   end
  # end
end
