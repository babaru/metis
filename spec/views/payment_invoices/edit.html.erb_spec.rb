require 'spec_helper'

describe "payment_invoices/edit" do
  before(:each) do
    @payment_invoice = assign(:payment_invoice, stub_model(PaymentInvoice))
  end

  it "renders the edit payment_invoice form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", payment_invoice_path(@payment_invoice), "post" do
    end
  end
end
