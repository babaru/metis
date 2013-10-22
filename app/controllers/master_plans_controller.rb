class MasterPlansController < ApplicationController
  # GET /master_plans
  # GET /master_plans.json
  def index
    @master_plans_grid = initialize_grid(MasterPlan)

    respond_to do |format|
      format.html # index.html.erb
      format.json { head :no_content }
    end
  end

  # GET /master_plans/1
  # GET /master_plans/1.json
  def show
    @master_plan = MasterPlan.find(params[:id])
    @candidate_media = @master_plan.candidate_media
    @selected_medium_id = @candidate_media.first.id if @candidate_media.count > 0
    @selected_medium_id = params[:medium_id] if params[:medium_id]
    if @selected_medium_id
      @master_plan_items_grid = initialize_grid(MasterPlanItem.where("master_plan_id=#{@master_plan.id} and medium_id=#{@selected_medium_id}").order('is_on_house, created_at'))
    end
    @selected_medium = Medium.find @selected_medium_id if @selected_medium_id

    respond_to do |format|
      format.html
      format.json { render json: @master_plan }
    end
  end

  def modify
    if request.post?
      @master_plan = MasterPlan.find params["id"]
      if @master_plan
        if params['name'] == 'medium_net_cost_per_medium'
          medium_id = params['selected_medium_id']
          mmp = @master_plan.medium_master_plans.where(medium_id: medium_id).first
          if mmp
            mmp.reality_medium_net_cost = params['value']
            mmp.save!
          end
        elsif params['name'] == 'company_net_cost_per_medium'
          medium_id = params['selected_medium_id']
          mmp = @master_plan.medium_master_plans.where(medium_id: medium_id).first
          if mmp
            mmp.reality_company_net_cost = params['value']
            mmp.save!
          end
        else
          @master_plan.send "#{params['name']}=", params["value"]
        end
        @master_plan.save!
      end

      respond_to do |format|
        format.json { render json: @master_plan, status: :ok }
        format.html { redirect_to client_project_master_plan_path(id: @master_plan, client_id: @master_plan.client_id, project_id: @master_plan.project_id), notice: 'Master plan was successfully updated.'}
      end
    end
  end

  def choose_spots
    @master_plan = MasterPlan.find(params[:id])
    @pool = Tida::Metis::SpotCandidate::Pool.new session
    @media = Medium.all
    @spot_picker = Tida::Metis::SpotPicker.new params
    @spots_grid = initialize_grid(Spot.where(@spot_picker.spots_query_clause), name: 'spot_candidates_grid') if @spot_picker.selected_medium

    respond_to do |format|
      format.html
      format.json { render json: @master_plan }
    end
  end

  def add_to_cart
    @master_plan = MasterPlan.find params[:id]
    @pool = Tida::Metis::SpotCandidate::Pool.new session
    if request.post?
      counts = params[:counts]
      is_on_houses = params[:is_on_houses]
      spot_ids = params[:spot_ids]
      counts.each_with_index do |item, index|
        next if item.nil? || item.strip == ''
        spot_id = spot_ids[index]
        spot = Spot.find spot_id
        is_on_house = is_on_houses.nil? ? false : is_on_houses.include?(spot_ids[index])
        @pool.add(spot, item.to_i, is_on_house) if spot
      end

      respond_to do |format|
        format.js
        # format.html { redirect_to choose_spots_path(id: @master_plan, client_id: @master_plan.client_id, project_id: @master_plan.project_id), notice: '添加到购物栏成功'}
      end
    end
  end

  def modify_cart
    @pool = Tida::Metis::SpotCandidate::Pool.new session
    if request.post?
      medium_id = params[:medium_id]
      spot_id = params[:spot_id]
      count = params[:count].to_i
      is_on_house = params[:is_on_house] == 'true' ? true : false
      new_count = count
      new_is_on_house = is_on_house
      new_count = params['value'].to_i if params['name'] == 'count'
      new_is_on_house = params['value'] == 'true' ? true : false if params['name'] == 'is_on_house'

      @pool.change(medium_id, spot_id, is_on_house, new_count, new_is_on_house)

      respond_to do |format|
        format.json { head :no_content }
      end
    end
  end

  def remove_from_cart
    @pool = Tida::Metis::SpotCandidate::Pool.new session
    @master_plan = MasterPlan.find params[:id]
    if request.post?
      medium_id = params[:medium_id].to_i
      key = params[:key]
      @pool.remove(medium_id, key)

      respond_to do |format|
        format.js
      end
    end
  end

  def remove_medium_from_cart
    @pool = Tida::Metis::SpotCandidate::Pool.new session
    @master_plan = MasterPlan.find params[:id]
    if request.post?
      medium_id = params[:medium_id].to_i
      @pool.remove_medium(medium_id)

      respond_to do |format|
        format.js
      end
    end
  end

  def clear_cart
    @pool = Tida::Metis::SpotCandidate::Pool.new session
    @master_plan = MasterPlan.find params[:id]
    if request.post?
      @pool.clear

      respond_to do |format|
        format.js
      end
    end
  end

  def go_combo
    @pool = Tida::Metis::SpotCandidate::Pool.new session
    @master_plan = MasterPlan.find params[:id]
    if request.post?
      medium_id = params[:medium_id]
      is_combo = params[:is_combo] == 'true' ? true : false

      @pool.go_combo(medium_id, is_combo)

      respond_to do |format|
        format.js
      end
    end
  end

  def save_candidates_to_master_plan
    @master_plan = MasterPlan.find params[:id]
    @pool = Tida::Metis::SpotCandidate::Pool.new session
    if request.post?
      MasterPlan.transaction do
        @pool.get_pool_keys.each do |pool_key|
          pool_options = @pool.get_options(pool_key)
          pool_items = @pool.get_items(pool_key)

          medium_master_plan = MediumMasterPlan.create_by_data!({
            medium_id: pool_options[:medium_id],
            medium_name: pool_options[:medium_name],
            master_plan_id: @master_plan.id,
            master_plan_name: @master_plan.name,
            is_combo: pool_options[:is_combo]
            })

          pool_items.map do |k, item|
            MasterPlanItem.create_by_data!({
              spot_id: item[:spot_id],
              master_plan_id: @master_plan.id,
              medium_master_plan_id: medium_master_plan.id,
              count: item[:count],
              is_on_house: item[:is_on_house],
              client_id: @master_plan.client_id,
              project_id: @master_plan.project_id,
              medium_id: item[:medium_id],
              channel_id: item[:channel_id]
            })
          end
        end

        @pool.clear
      end

      respond_to do |format|
        format.html {redirect_to client_project_master_plan_path(id: @master_plan, client_id: @master_plan.client_id, project_id: @master_plan.project_id), notice: 'Master plan was successfully saved.'}
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

  def spot_plan
    @master_plan = MasterPlan.find params[:id]
    @candidate_media = @master_plan.candidate_media
    @selected_medium_id = @candidate_media.first.id if @candidate_media.count > 0
    @selected_medium_id = params[:medium_id] if params[:medium_id]
    @master_plan_items = MasterPlanItem.where('master_plan_id=? and medium_id=?', @master_plan.id, @selected_medium_id).order('is_on_house, created_at')
    @working_version = params[:wv]
    @working_version = @master_plan.working_version if params[:wv].nil?
    @selected_medium = Medium.find @selected_medium_id if @selected_medium_id

    @months = @master_plan.project.months
    @days = @master_plan.project.days

    if @months.length > 0
      @selected_month = @months.first[:month].to_i
      @selected_year = @months.first[:year].to_i
    end
    @selected_month = params[:m].to_i if params[:m]
    @selected_year = params[:y].to_i if params[:y]

    @selected_days = []
    if @selected_month && @selected_year
      @selected_days = @days["#{@selected_year}#{sprintf('%02d', @selected_month)}"]
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @master_plan_items }
    end
  end

  def generate_spot_plan
    if request.post?
      file = Tida::Metis::ExcelGenerators::SpotPlans::CaratGenerator.new(params[:id]).generate()
      send_file file, :type=>"application/vnd.ms-excel", :x_sendfile=>true
    end
  end

  def save_spot_plan
    @master_plan = MasterPlan.find(params[:id])
    if request.post?
      @master_plan.save_version!
      respond_to do |format|
        format.html { redirect_to spot_plan_path(master_plan_id: @master_plan), notice: 'This version spot plan was successfully save.' }
      end
    end
  end
end
