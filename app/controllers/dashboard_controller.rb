class DashboardController < ApplicationController
  before_filter :authenticate_user!

  def index
    @projects_grid = initialize_grid(Project.order('client_id'))
  end
end
