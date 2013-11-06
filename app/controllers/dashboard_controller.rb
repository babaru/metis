class DashboardController < ApplicationController
  before_filter :authenticate_user!

  def index
    @projects_grid = initialize_grid(Project.joins(:client).where('clients.space_id=?', current_space.id).order('client_id'))
  end
end
