class MasterPlansController < ApplicationController
  # GET /master_plans
  # GET /master_plans.json
  def index
    @master_plans_grid = initialize_grid(MasterPlan)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @master_plans_grid }
    end
  end

  # GET /master_plans/1
  # GET /master_plans/1.json
  def show
    @master_plan = MasterPlan.find(params[:id])
    @master_plan_items_grid = initialize_grid(MasterPlanItem.where(master_plan_id: @master_plan.id).order('created_at'))

    respond_to do |format|
      format.html
      format.json { render json: @master_plan }
    end
  end

  def choose_spots
    @master_plan = MasterPlan.find(params[:id])
    @websites = Website.all
    @spots_filter = SpotsFilter.new params
    @spots_grid = initialize_grid(Spot.where(@spots_filter.spots_query_clause), name: 'candidates_grid') if @spots_filter.selected_website

    respond_to do |format|
      format.html
      format.json { render json: @master_plan }
    end
  end

  def candidates
    @master_plan = MasterPlan.find params[:id]
    spot_ids = [0]
    spot_ids = params[:candidates_grid][:selected] if params[:candidates_grid] && params[:candidates_grid][:selected]
    @spots_grid = initialize_grid(Spot.where("id in (#{spot_ids.join(',')})"))

    respond_to do |format|
      format.js
    end
  end

  def save_candidates
    @master_plan = MasterPlan.find params[:id]
    spot_ids = params[:spot_id]
    counts = params[:day_count]
    if spot_ids && spot_ids.length > 0
      spot_ids.each_with_index do |item, index|
        @master_plan.items << MasterPlanItem.new(spot_id: item, count: counts[index].to_f)
      end
    end
    @master_plan.save!
    @master_plan_items_grid = initialize_grid(MasterPlanItem.where(master_plan_id: @master_plan.id).order('created_at'))

    respond_to do |format|
      format.js
    end
  end

  # GET /master_plans/new
  # GET /master_plans/new.json
  def new
    @project = Project.find params[:project_id]
    @master_plan = MasterPlan.new
    @master_plan.project_id = @project.id
    @master_plan.created_by_id = current_user.id

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @master_plan }
    end
  end

  # GET /master_plans/1/edit
  def edit
    @master_plan = MasterPlan.find(params[:id])
  end

  # POST /master_plans
  # POST /master_plans.json
  def create
    @master_plan = MasterPlan.new(params[:master_plan])

    respond_to do |format|
      if @master_plan.save
        format.html { redirect_to master_plan_path(@master_plan), notice: 'Master plan was successfully created.' }
        format.json { render json: @master_plan, status: :created, location: @master_plan }
      else
        format.html { render action: "new" }
        format.json { render json: @master_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /master_plans/1
  # PATCH/PUT /master_plans/1.json
  def update
    @master_plan = MasterPlan.find(params[:id])

    respond_to do |format|
      if @master_plan.update_attributes(params[:master_plan])
        format.html { redirect_to master_plan_path(@master_plan), notice: 'Master plan was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @master_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /master_plans/1
  # DELETE /master_plans/1.json
  def destroy
    @master_plan = MasterPlan.find(params[:id])
    @master_plan.destroy

    respond_to do |format|
      format.html { redirect_to master_plans_url }
      format.json { head :no_content }
    end
  end
end
