class DashboardController < ApplicationController
  before_filter :authenticate_user!

  def index
    if current_space
      @projects_grid = initialize_grid(Project.joins(:client).where('clients.space_id=?', current_space.id).order('client_id'))
    end
  end
end
