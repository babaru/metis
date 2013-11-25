require 'spec_helper'

describe "collection_invoices/edit" do
  before(:each) do
    @collection_invoice = assign(:collection_invoice, stub_model(CollectionInvoice))
  end

  it "renders the edit collection_invoice form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", collection_invoice_path(@collection_invoice), "post" do
    end
  end
end
