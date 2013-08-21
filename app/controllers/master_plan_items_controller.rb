class MasterPlanItemsController < ApplicationController
  include ActionView::Helpers::NumberHelper

  # GET /master_plan_items
  # GET /master_plan_items.json
  def index
    @master_plan = MasterPlan.find params[:master_plan_id]
    @candidate_websites = Website.find_by_sql("select * from websites where id in (select distinct website_id from master_plan_items left join spots on master_plan_items.spot_id = spots.id where master_plan_items.master_plan_id=#{@master_plan.id})")
    @selected_website_id = @candidate_websites.first.id if @candidate_websites.count > 0
    @selected_website_id = params[:website_id] if params[:website_id]

    @master_plan_items = MasterPlanItem.joins('left outer join spots on master_plan_items.spot_id = spots.id').where('master_plan_items.master_plan_id=? and spots.website_id=?', params[:master_plan_id], @selected_website_id).order('is_on_house, created_at')

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
        @master_plan_item.save!
      end

      respond_to do |format|
        format.json { render json: {
          contract_price: number_to_currency(@master_plan_item.master_plan.contract_price, unit: '', precision: 0),
          profit: number_to_currency(@master_plan_item.master_plan.profit, unit: '', precision: 0),
          run_time_on_house_rate: @master_plan_item.master_plan.on_house_rate(params[:selected_website_id]),
          is_on_house: @master_plan_item.is_on_house
        }}
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
