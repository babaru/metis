require 'spec_helper'

describe "space_users/edit" do
  before(:each) do
    @space_user = assign(:space_user, stub_model(SpaceUser))
  end

  it "renders the edit space_user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", space_user_path(@space_user), "post" do
    end
  end
end
