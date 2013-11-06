require 'spec_helper'

describe "space_users/show" do
  before(:each) do
    @space_user = assign(:space_user, stub_model(SpaceUser))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
