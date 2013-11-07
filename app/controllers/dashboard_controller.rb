class DashboardController < ApplicationController
  before_filter :authenticate_user!

  def index
    if @space
      @projects_grid = initialize_grid(Project.joins(:client).where('clients.space_id=?', @space.id).where('started_at <= ? AND ended_at >= ?', Time.now.strftime('%Y-%m-%d'), Time.now.strftime('%Y-%m-%d')).order('client_id'))
    end
  end
end
