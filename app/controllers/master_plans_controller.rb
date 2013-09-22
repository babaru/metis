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
    @candidate_websites = @master_plan.candidate_websites
    @selected_website_id = @candidate_websites.first.id if @candidate_websites.count > 0
    @selected_website_id = params[:website_id] if params[:website_id]
    if @selected_website_id
      @master_plan_items_grid = initialize_grid(MasterPlanItem.where("master_plan_id=#{@master_plan.id} and website_id=#{@selected_website_id}").order('created_at'))
    end

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
    if request.post?
      counts = params[:count]
      spot_ids = params[:spot_id]
      is_on_houses = params[:is_on_house]
      website_id = params[:website_id]
      channel_id = params[:channel_id]
      counts.each_with_index do |item, index|
        next if item.nil? || item.strip == ''
        @master_plan.items << MasterPlanItem.new({
          spot_id: spot_ids[index],
          count: item,
          is_on_house: is_on_houses.nil? ? false : is_on_houses.include?(spot_ids[index]),
          client_id: @master_plan.client_id,
          project_id: @master_plan.project_id,
          website_id: website_id,
          channel_id: channel_id
          })
      end
      @master_plan.save!

      respond_to do |format|
        format.html {redirect_to master_plan_path(@master_plan), notice: 'Master plan was successfully saved.'}
      end
    end
  end

  # GET /master_plans/new
  # GET /master_plans/new.json
  def new
    @project = Project.find params[:project_id]
    @master_plan = MasterPlan.new
    @master_plan.project_id = @project.id
    @master_plan.client_id = @project.client_id
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

  def save_version
    @master_plan = MasterPlan.find(params[:master_plan_id])
    if request.post?
      @master_plan.save_version!
      respond_to do |format|
        format.html { redirect_to spot_plan_path(master_plan_id: @master_plan), notice: 'This version spot plan was successfully save.' }
      end
    end
  end
end
