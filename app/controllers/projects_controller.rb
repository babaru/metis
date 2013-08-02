class ProjectsController < ApplicationController
  # GET /projects
  # GET /projects.json
  def index
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
    @master_plans_grid = initialize_grid(MasterPlan.where(project_id: @project))
  end

  def view_cart
    @selected_spot_ids = []
    @selected_spot_ids = params[:spots].split(',') if params[:spots]
    @project = Project.find(params[:id])

    @spots_grid = initialize_grid(Spot.where("id in (#{@selected_spot_ids.join(',')})"))
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = Project.new
    @project.client_id = params[:client_id]
    @project.created_by_id = current_user.id

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
        format.html { redirect_to project_path(@project), notice: 'Project was successfully created.' }
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
        format.html { redirect_to project_path(@project), notice: 'Project was successfully updated.' }
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
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end
end
