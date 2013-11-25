require "spec_helper"

describe CollectionInvoicesController do
  describe "routing" do

    it "routes to #index" do
      get("/collection_invoices").should route_to("collection_invoices#index")
    end

    it "routes to #new" do
      get("/collection_invoices/new").should route_to("collection_invoices#new")
    end

    it "routes to #show" do
      get("/collection_invoices/1").should route_to("collection_invoices#show", :id => "1")
    end

    it "routes to #edit" do
      get("/collection_invoices/1/edit").should route_to("collection_invoices#edit", :id => "1")
    end

    it "routes to #create" do
      post("/collection_invoices").should route_to("collection_invoices#create")
    end

    it "routes to #update" do
      put("/collection_invoices/1").should route_to("collection_invoices#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/collection_invoices/1").should route_to("collection_invoices#destroy", :id => "1")
    end

  end
end
