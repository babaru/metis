class SpotPlanItemsController < ApplicationController
  # GET /spot_plan_items
  # GET /spot_plan_items.json
  def index
    @master_plan_item = MasterPlanItem.find params[:master_plan_item_id]
    @spot_plan_version = params[:version]
    @spot_plan_version = @master_plan_item.master_plan.spot_plan_version if params[:version].nil?
    @selected_month = params[:m]
    @selected_year = params[:y]
    @spot_plan_items = SpotPlanItem.where(master_plan_item_id: params[:master_plan_item_id], version: @spot_plan_version, placed_at: [Time.parse("#{@selected_year}-#{@selected_month}-01")..Time.parse("#{@selected_year}-#{@selected_month.to_i + 1}-01")]).order('placed_at')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @spot_plan_items }
    end
  end

  # GET /spot_plan_items/1
  # GET /spot_plan_items/1.json
  def show
    @spot_plan_item = SpotPlanItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @spot_plan_item }
    end
  end

  # GET /spot_plan_items/new
  # GET /spot_plan_items/new.json
  def new
    @spot_plan_item = SpotPlanItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @spot_plan_item }
    end
  end

  # GET /spot_plan_items/1/edit
  def edit
    @spot_plan_item = SpotPlanItem.find(params[:id])
  end

  # POST /spot_plan_items
  # POST /spot_plan_items.json
  def create
    data = {}
    data[:master_plan_id] = params[:spot_plan_item][:master_plan_id]
    data[:master_plan_item_id] = params[:spot_plan_item][:master_plan_item_id]
    data[:placed_at] = Time.parse(params[:spot_plan_item][:placed_at])
    data[:version] = params[:spot_plan_item][:version]
    data[:count] = params[:spot_plan_item][:count]

    SpotPlanItem.transaction do
      @spot_plan_item = SpotPlanItem.create_by_data!(data)
      @spot_plan_item.master_plan_item.master_plan.is_dirty = true
      @spot_plan_item.master_plan_item.master_plan.save!
    end

    respond_to do |format|
      format.json { render json: @spot_plan_item, status: :created, location: @spot_plan_item }
    end
  end

  # PATCH/PUT /spot_plan_items/1
  # PATCH/PUT /spot_plan_items/1.json
  def update
    @spot_plan_item = SpotPlanItem.find(params[:id])

    SpotPlanItem.transaction do
      @spot_plan_item.update_attributes!(params[:spot_plan_item])
      @spot_plan_item.master_plan_item.master_plan.is_dirty = true
      @spot_plan_item.master_plan_item.master_plan.save!
      respond_to do |format|
        format.html { redirect_to spot_plan_item_path(@spot_plan_item), notice: 'Spot plan item was successfully updated.' }
        format.json { render json: @spot_plan_item, status: :ok, location: @spot_plan_item }
      end
    end
  end

  # DELETE /spot_plan_items/1
  # DELETE /spot_plan_items/1.json
  def destroy
    @spot_plan_item = SpotPlanItem.find(params[:id])
    @spot_plan_item.destroy

    respond_to do |format|
      format.html { redirect_to spot_plan_items_url }
      format.json { head :no_content }
    end
  end

  def modify_placed_at
    @spot_plan_item = SpotPlanItem.find params[:id]
    if request.post?
      SpotPlanItem.transaction do
        new_placed_at = params[:spot_plan_item][:placed_at]
        @new_spot_plan_item = @spot_plan_item.change_placed_at!(Time.parse(new_placed_at))
        @spot_plan_item.master_plan_item.master_plan.is_dirty = true
        @spot_plan_item.master_plan_item.master_plan.save!
        respond_to do |format|
          format.json { render json: { new_item: @new_spot_plan_item, origin: @spot_plan_item } }
        end
      end
    end
  end
end
