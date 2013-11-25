require 'spec_helper'

describe "collection_invoices/index" do
  before(:each) do
    assign(:collection_invoices, [
      stub_model(CollectionInvoice),
      stub_model(CollectionInvoice)
    ])
  end

  it "renders a list of collection_invoices" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
