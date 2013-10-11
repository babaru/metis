require "spec_helper"

describe MediumPoliciesController do
  describe "routing" do

    it "routes to #index" do
      get("/medium_policies").should route_to("medium_policies#index")
    end

    it "routes to #new" do
      get("/medium_policies/new").should route_to("medium_policies#new")
    end

    it "routes to #show" do
      get("/medium_policies/1").should route_to("medium_policies#show", :id => "1")
    end

    it "routes to #edit" do
      get("/medium_policies/1/edit").should route_to("medium_policies#edit", :id => "1")
    end

    it "routes to #create" do
      post("/medium_policies").should route_to("medium_policies#create")
    end

    it "routes to #update" do
      put("/medium_policies/1").should route_to("medium_policies#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/medium_policies/1").should route_to("medium_policies#destroy", :id => "1")
    end

  end
end
