class MasterPlanItemsController < ApplicationController
  include ActionView::Helpers::NumberHelper

  # GET /master_plan_items
  # GET /master_plan_items.json
  def index
    @master_plan = MasterPlan.find params[:master_plan_id]
    @candidate_media = @master_plan.candidate_media
    @selected_medium_id = @candidate_media.first.id if @candidate_media.count > 0
    @selected_medium_id = params[:medium_id] if params[:medium_id]
    @master_plan_items = MasterPlanItem.where('master_plan_id=? and medium_id=?', params[:master_plan_id], @selected_medium_id).order('is_on_house, created_at')
    # @working_version = params[:wv]
    # @working_version = @master_plan.working_version if params[:wv].nil?

    # @months = @master_plan.project.months
    # @days = @master_plan.project.days

    # if @months.length > 0
    #   @selected_month = @months.first[:month].to_i
    #   @selected_year = @months.first[:year].to_i
    # end
    # @selected_month = params[:m].to_i if params[:m]
    # @selected_year = params[:y].to_i if params[:y]

    # @selected_days = []
    # if @selected_month && @selected_year
    #   @selected_days = @days["#{@selected_year}#{sprintf('%02d', @selected_month)}"]
    # end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @master_plan_items }
    end
  end

  # GET /master_plan_items/1
  # GET /master_plan_items/1.json
  def show
    @master_plan_item = MasterPlanItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @master_plan_item }
    end
  end

  # GET /master_plan_items/new
  # GET /master_plan_items/new.json
  def new
    @master_plan_item = MasterPlanItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @master_plan_item }
    end
  end

  def modify
    if request.post?
      @master_plan_item = MasterPlanItem.find params["id"]
      if @master_plan_item
        @master_plan_item.send "#{params['name']}=", params["value"]
        @master_plan_item.est_total_imp = @master_plan_item.est_imp * @master_plan_item.count if @master_plan_item.est_imp
        @master_plan_item.est_total_clicks = @master_plan_item.est_clicks * @master_plan_item.count if @master_plan_item.est_clicks
        @master_plan_item.est_ctr = @master_plan_item.est_clicks.to_f / @master_plan_item.est_imp.to_f if @master_plan_item.est_clicks && @master_plan_item.est_imp
        @master_plan_item.save!
      end

      respond_to do |format|
        format.json { render json: @master_plan_item, status: :ok }
        format.html { redirect_to master_plan_path(@master_plan_item.master_plan_id), notice: 'Master plan item was successfully updated.'}
      end
    end
  end

  # GET /master_plan_items/1/edit
  def edit
    @master_plan_item = MasterPlanItem.find(params[:id])
  end

  # POST /master_plan_items
  # POST /master_plan_items.json
  def create
    @master_plan_item = MasterPlanItem.new(params[:master_plan_item])

    respond_to do |format|
      if @master_plan_item.save
        format.html { redirect_to master_plan_item_path(@master_plan_item), notice: 'Master plan item was successfully created.' }
        format.json { render json: @master_plan_item, status: :created, location: @master_plan_item }
      else
        format.html { render action: "new" }
        format.json { render json: @master_plan_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /master_plan_items/1
  # PATCH/PUT /master_plan_items/1.json
  def update
    @master_plan_item = MasterPlanItem.find(params[:id])

    respond_to do |format|
      if @master_plan_item.update_attributes(params[:master_plan_item])
        format.html { redirect_to master_plan_item_path(@master_plan_item), notice: 'Master plan item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @master_plan_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /master_plan_items/1
  # DELETE /master_plan_items/1.json
  def destroy
    @master_plan_item = MasterPlanItem.find(params[:id])
    master_plan_id = @master_plan_item.master_plan_id
    @master_plan_item.destroy

    respond_to do |format|
      format.html { redirect_to master_plan_path(master_plan_id) }
      format.json { head :no_content }
    end
  end
end
