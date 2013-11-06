require 'spec_helper'

describe "space_users/new" do
  before(:each) do
    assign(:space_user, stub_model(SpaceUser).as_new_record)
  end

  it "renders new space_user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", space_users_path, "post" do
    end
  end
end
