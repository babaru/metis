require 'spec_helper'

describe "media/index" do
  before(:each) do
    assign(:media, [
      stub_model(Medium),
      stub_model(Medium)
    ])
  end

  # it "renders a list of media" do
    # render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  # end
end
