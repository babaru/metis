require 'spec_helper'

describe "shopping_cart_items/new" do
  before(:each) do
    assign(:shopping_cart_item, stub_model(ShoppingCartItem).as_new_record)
  end

  it "renders new shopping_cart_item form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", shopping_cart_items_path, "post" do
    end
  end
end
