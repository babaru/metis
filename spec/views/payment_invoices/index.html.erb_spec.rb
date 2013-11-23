require 'spec_helper'

describe "payment_invoices/index" do
  before(:each) do
    assign(:payment_invoices, [
      stub_model(PaymentInvoice),
      stub_model(PaymentInvoice)
    ])
  end

  it "renders a list of payment_invoices" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
