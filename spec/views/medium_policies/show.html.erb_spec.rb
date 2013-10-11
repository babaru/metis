require 'spec_helper'

describe "medium_policies/show" do
  before(:each) do
    @medium_policy = assign(:medium_policy, stub_model(MediumPolicy))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
