class FinanceController < ApplicationController
  def report
    @kind = 'payment'
    @kind = params[:kind].downcase if params[:kind]
    @project_search = ProjectSearch.new
  end

  def do_query_projects
    @kind = params[:kind]

    if request.post?
      @project_search = ProjectSearch.new(params[:project_search])
      @projects = Project.where(@project_search.conditions).order('client_id, started_at asc, ended_at asc')

      respond_to do |format|
        format.js
      end
    end
  end

  def generate_report
    @kind = params[:kind]

    if request.post?
      if params[:download_report]
      else
        # Genreate report
        if @kind == 'payment'
          @payments_grid = initialize_grid(Payment
            .where("project_id in (#{params[:project_ids].join(',')})")
            .order('payments.client_id ASC, payments.project_id ASC, payments.medium_id ASC, payments.paid_at ASC'))
        else
          @collections_grid = initialize_grid(Project.where("id in (#{params[:project_ids].join(',')})"))
        end

        respond_to do |format|
          format.js
        end

      end
    # @payments = Payment.where(project_id: 47)
    end
  end
end
