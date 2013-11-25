require 'spec_helper'

describe "collection_invoices/show" do
  before(:each) do
    @collection_invoice = assign(:collection_invoice, stub_model(CollectionInvoice))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
