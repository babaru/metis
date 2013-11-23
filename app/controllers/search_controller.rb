class SearchController < ApplicationController
  def query_projects
    @project_search = ProjectSearch.new
  end

  def do_query_projects
    if request.post?
      @project_search = ProjectSearch.new(params[:project_search])
      @projects_grid = initialize_grid(Project.where(@project_search.conditions))

      respond_to do |format|
        format.js
      end
    end
  end
end
