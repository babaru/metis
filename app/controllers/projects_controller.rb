class ProjectsController < ApplicationController
  add_breadcrumb(I18n.t('model.list', model: Client.model_name.human), :clients_path, only: :index)

  # GET /projects
  # GET /projects.json
  def index
    @client = Client.find params[:client_id]
    add_breadcrumb("#{@client.name} #{t('model.list', model: Project.model_name.human)}")
    @projects_grid = initialize_grid(Project.where(client_id: params[:client_id]))

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects_grid }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = Project.find params[:id]
    @master_plan = @project.master_plans.order('created_at DESC').first
  end

  def assign_user
    @project = Project.find params[:id]
    @client = @project.client
  end

  def save_user_assignments
    if request.post?
      @project = Project.find(params[:id])

      respond_to do |format|
        if @project.update_attributes(params[:project])
          format.html { redirect_to client_projects_path(@project.client_id), notice: "保存#{ProjectAssignment.model_name.human}成功！" }
          format.json { head :no_content }
        else
          format.html { render action: "assigns" }
          format.json { render json: @project.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def set_current_master_plan
    @project = Project.find(params[:id])
    if request.post?
      @project.current_master_plan_id = params[:master_plan_id]
      @project.save!

      respond_to do |format|
        if @project.update_attributes(params[:project])
          format.html { redirect_to client_project_master_plan_path(client_id: @project.client_id, project_id: @project.id, id: @project.current_master_plan_id), notice: "设置缺省MasterPlan成功！" }
        end
      end
    end
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = Project.new
    @project.client_id = params[:client_id]
    @project.created_by_id = current_user.id

    add_breadcrumb("#{@project.client.name} #{t('model.list', model: Project.model_name.human)}", client_projects_path(client_id: @project.client_id))
    add_breadcrumb(t('model.create', model: Project.model_name.human))

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
    add_breadcrumb("#{@project.client.name} #{t('model.list', model: Project.model_name.human)}", client_projects_path(client_id: @project.client_id))
    add_breadcrumb(t('model.edit', model: Project.model_name.human))
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(params[:project])
    @project.assigned_users << current_user

    respond_to do |format|
      if @project.save
        format.html { redirect_to assign_project_user_path(@project), notice: "成功创建#{Project.model_name.human}" }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to client_project_master_plan_path(id: @project.current_master_plan_id, client_id: @project.client_id, project_id: @project.id), notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project = Project.find(params[:id])
    client_id = @project.client_id
    @project.destroy

    respond_to do |format|
      format.html { redirect_to client_projects_path(client_id) }
      format.json { head :no_content }
    end
  end

  def start
    @project = Project.find params[:id]

    if request.post?
      @project.start!

      respond_to do |format|
        format.html { redirect_to client_projects_path(@project.client_id) }
        format.json { head :no_content }
      end
    end
  end

  def execution
    @project = Project.find params[:id]
    @project.current_master_plan.medium_master_plans.each do |medium_master_plan|
      unless medium_master_plan.regular_medium_rebate
        medium_master_plan.regular_medium_rebate = CompanyPolicy.rebate(@project.client_id, medium_master_plan.medium_id)
        medium_master_plan.save!
      end
    end
  end
end
