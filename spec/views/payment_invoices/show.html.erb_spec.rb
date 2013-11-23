require 'spec_helper'

describe "payment_invoices/show" do
  before(:each) do
    @payment_invoice = assign(:payment_invoice, stub_model(PaymentInvoice))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
