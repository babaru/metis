require 'spec_helper'

describe "medium_policies/index" do
  before(:each) do
    assign(:medium_policies, [
      stub_model(MediumPolicy),
      stub_model(MediumPolicy)
    ])
  end

  # it "renders a list of medium_policies" do
  #   render
  #   # Run the generator again with the --webrat flag if you want to use webrat matchers
  # end
end
