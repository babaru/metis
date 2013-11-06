require 'spec_helper'

describe "spaces/edit" do
  before(:each) do
    @space = assign(:space, stub_model(Space))
  end

  it "renders the edit space form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", space_path(@space), "post" do
    end
  end
end
