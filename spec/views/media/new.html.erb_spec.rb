require 'spec_helper'

describe "media/new" do
  before(:each) do
    assign(:medium, stub_model(Medium).as_new_record)
  end

  it "renders new medium form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", media_path, "post" do
    end
  end
end
