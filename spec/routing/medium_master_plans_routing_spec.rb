require "spec_helper"

describe MediumMasterPlansController do
  describe "routing" do

    it "routes to #index" do
      get("/medium_master_plans").should route_to("medium_master_plans#index")
    end

    it "routes to #new" do
      get("/medium_master_plans/new").should route_to("medium_master_plans#new")
    end

    it "routes to #show" do
      get("/medium_master_plans/1").should route_to("medium_master_plans#show", :id => "1")
    end

    it "routes to #edit" do
      get("/medium_master_plans/1/edit").should route_to("medium_master_plans#edit", :id => "1")
    end

    it "routes to #create" do
      post("/medium_master_plans").should route_to("medium_master_plans#create")
    end

    it "routes to #update" do
      put("/medium_master_plans/1").should route_to("medium_master_plans#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/medium_master_plans/1").should route_to("medium_master_plans#destroy", :id => "1")
    end

  end
end
