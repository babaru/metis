require 'spec_helper'

describe "shopping_cart_items/edit" do
  before(:each) do
    @shopping_cart_item = assign(:shopping_cart_item, stub_model(ShoppingCartItem))
  end

  it "renders the edit shopping_cart_item form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", shopping_cart_item_path(@shopping_cart_item), "post" do
    end
  end
end
