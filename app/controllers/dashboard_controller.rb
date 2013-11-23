class DashboardController < ApplicationController
  before_filter :authenticate_user!

  def index
    @projects_grid = initialize_grid(
      Project
        .joins(:client)
        .where(
          'clients.space_id=? and started_at <= ? AND ended_at >= ?',
          current_space.id,
          Time.now.strftime('%Y-%m-%d'),
          Time.now.strftime('%Y-%m-%d')
        )
        .order('client_id')
    )
  end
end
