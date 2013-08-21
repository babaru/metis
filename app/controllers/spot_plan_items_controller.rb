class SpotPlanItemsController < ApplicationController
  # GET /spot_plan_items
  # GET /spot_plan_items.json
  def index
    @spot_plan_items_grid = initialize_grid(SpotPlanItem)

    @spot_plan_items = SpotPlanItem.where(master_plan_item_id: params[:master_plan_item_id]).order('placed_at')

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
    @spot_plan_item = SpotPlanItem.where(master_plan_item_id: params[:spot_plan_item][:master_plan_item_id], placed_at: Time.parse(params[:spot_plan_item][:placed_at])).first
    if @spot_plan_item.nil?
      @spot_plan_item = SpotPlanItem.new(params[:spot_plan_item])
      @spot_plan_item.created_by_id = current_user.id
    end

    respond_to do |format|
      if @spot_plan_item.save
        # format.html { redirect_to spot_plan_item_path(@spot_plan_item), notice: 'Spot plan item was successfully created.' }
        format.json { render json: @spot_plan_item, status: :created, location: @spot_plan_item }
      else
        # format.html { render action: "new" }
        format.json { render json: @spot_plan_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /spot_plan_items/1
  # PATCH/PUT /spot_plan_items/1.json
  def update
    @spot_plan_item = SpotPlanItem.find(params[:id])

    respond_to do |format|
      if @spot_plan_item.update_attributes(params[:spot_plan_item])
        format.html { redirect_to spot_plan_item_path(@spot_plan_item), notice: 'Spot plan item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @spot_plan_item.errors, status: :unprocessable_entity }
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
end