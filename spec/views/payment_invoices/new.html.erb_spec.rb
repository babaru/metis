require 'spec_helper'

describe "payment_invoices/new" do
  before(:each) do
    assign(:payment_invoice, stub_model(PaymentInvoice).as_new_record)
  end

  it "renders new payment_invoice form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", payment_invoices_path, "post" do
    end
  end
end
