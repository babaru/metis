require 'spec_helper'

describe "collection_invoices/new" do
  before(:each) do
    assign(:collection_invoice, stub_model(CollectionInvoice).as_new_record)
  end

  it "renders new collection_invoice form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", collection_invoices_path, "post" do
    end
  end
end
