require "spec_helper"

describe CompanyPoliciesController do
  describe "routing" do

    it "routes to #index" do
      get("/company_policies").should route_to("company_policies#index")
    end

    it "routes to #new" do
      get("/company_policies/new").should route_to("company_policies#new")
    end

    it "routes to #show" do
      get("/company_policies/1").should route_to("company_policies#show", :id => "1")
    end

    it "routes to #edit" do
      get("/company_policies/1/edit").should route_to("company_policies#edit", :id => "1")
    end

    it "routes to #create" do
      post("/company_policies").should route_to("company_policies#create")
    end

    it "routes to #update" do
      put("/company_policies/1").should route_to("company_policies#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/company_policies/1").should route_to("company_policies#destroy", :id => "1")
    end

  end
end
