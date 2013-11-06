require "spec_helper"

describe SpaceUsersController do
  describe "routing" do

    it "routes to #index" do
      get("/space_users").should route_to("space_users#index")
    end

    it "routes to #new" do
      get("/space_users/new").should route_to("space_users#new")
    end

    it "routes to #show" do
      get("/space_users/1").should route_to("space_users#show", :id => "1")
    end

    it "routes to #edit" do
      get("/space_users/1/edit").should route_to("space_users#edit", :id => "1")
    end

    it "routes to #create" do
      post("/space_users").should route_to("space_users#create")
    end

    it "routes to #update" do
      put("/space_users/1").should route_to("space_users#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/space_users/1").should route_to("space_users#destroy", :id => "1")
    end

  end
end
