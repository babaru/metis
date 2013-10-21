require 'spec_helper'

describe "shopping_cart_items/index" do
  before(:each) do
    assign(:shopping_cart_items, [
      stub_model(ShoppingCartItem),
      stub_model(ShoppingCartItem)
    ])
  end

  it "renders a list of shopping_cart_items" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
