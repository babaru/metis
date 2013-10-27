class MediumMasterPlansController < ApplicationController
  # GET /medium_master_plans
  # GET /medium_master_plans.json
  def index
    @medium_master_plans_grid = initialize_grid(MediumMasterPlan)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @medium_master_plans_grid }
    end
  end

  # GET /medium_master_plans/1
  # GET /medium_master_plans/1.json
  def show
    @medium_master_plan = MediumMasterPlan.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @medium_master_plan }
    end
  end

  # GET /medium_master_plans/new
  # GET /medium_master_plans/new.json
  def new
    @medium_master_plan = MediumMasterPlan.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @medium_master_plan }
    end
  end

  # GET /medium_master_plans/1/edit
  def edit
    @medium_master_plan = MediumMasterPlan.find(params[:id])
  end

  # POST /medium_master_plans
  # POST /medium_master_plans.json
  def create
    @medium_master_plan = MediumMasterPlan.new(params[:medium_master_plan])

    respond_to do |format|
      if @medium_master_plan.save
        format.html { redirect_to medium_master_plan_path(@medium_master_plan), notice: 'Medium master plan was successfully created.' }
        format.json { render json: @medium_master_plan, status: :created, location: @medium_master_plan }
      else
        format.html { render action: "new" }
        format.json { render json: @medium_master_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /medium_master_plans/1
  # PATCH/PUT /medium_master_plans/1.json
  def update
    @medium_master_plan = MediumMasterPlan.find(params[:id])

    respond_to do |format|
      if @medium_master_plan.update_attributes(params[:medium_master_plan])
        format.html { redirect_to medium_master_plan_path(@medium_master_plan), notice: 'Medium master plan was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @medium_master_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  def get_combo
    @medium_master_plan = MediumMasterPlan.find params[:id]
    if request.post?
      @medium_master_plan.type = ComboMediumMasterPlan.name
      @medium_master_plan.save!
      respond_to do |format|
        format.html { redirect_to client_project_master_plan_path(id: @medium_master_plan.master_plan_id, client_id: @medium_master_plan.master_plan.client_id, project_id: @medium_master_plan.master_plan.project_id, medium_id: @medium_master_plan.medium_id), notice: '已变成打包价.' }
      end
    end
  end

  def out_of_combo
    @medium_master_plan = MediumMasterPlan.find params[:id]
    if request.post?
      @medium_master_plan.type = MediumMasterPlan.name
      @medium_master_plan.save!
      respond_to do |format|
        format.html { redirect_to client_project_master_plan_path(id: @medium_master_plan.master_plan_id, client_id: @medium_master_plan.master_plan.client_id, project_id: @medium_master_plan.master_plan.project_id, medium_id: @medium_master_plan.medium_id), notice: '已变成打包价.' }
      end
    end
  end

  def modify
    @medium_master_plan = MediumMasterPlan.find params[:id]
    if request.post?
      @medium_master_plan.send "#{params['name']}=", params["value"]
      @medium_master_plan.save!

      respond_to do |format|
        format.json { render json: @medium_master_plan, status: :ok }
      end
    end
  end

  # DELETE /medium_master_plans/1
  # DELETE /medium_master_plans/1.json
  def destroy
    @medium_master_plan = MediumMasterPlan.find(params[:id])
    @medium_master_plan.destroy

    respond_to do |format|
      format.html { redirect_to medium_master_plans_url }
      format.json { head :no_content }
    end
  end
end
