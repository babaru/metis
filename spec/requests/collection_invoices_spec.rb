require 'spec_helper'

describe "CollectionInvoices" do
  describe "GET /collection_invoices" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get collection_invoices_path
      response.status.should be(200)
    end
  end
end
