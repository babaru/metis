require 'spec_helper'

describe "spaces/index" do
  before(:each) do
    assign(:spaces, [
      stub_model(Space),
      stub_model(Space)
    ])
  end

  it "renders a list of spaces" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
