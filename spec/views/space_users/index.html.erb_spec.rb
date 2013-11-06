require 'spec_helper'

describe "space_users/index" do
  before(:each) do
    assign(:space_users, [
      stub_model(SpaceUser),
      stub_model(SpaceUser)
    ])
  end

  it "renders a list of space_users" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
