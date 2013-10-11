class SpotPlanItemsController < ApplicationController
  # GET /spot_plan_items
  # GET /spot_plan_items.json
  def index
    @master_plan_item = MasterPlanItem.find params[:master_plan_item_id]
    @working_version = params[:wv]
    @working_version = @master_plan_item.master_plan.working_version if params[:wv].nil?
    @spot_plan_items = SpotPlanItem.where(master_plan_item_id: params[:master_plan_item_id], version: @working_version).order('placed_at')

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
      @master_plan_item = MasterPlanItem.find params[:spot_plan_item][:master_plan_item_id]
      @spot_plan_item = SpotPlanItem.new(params[:spot_plan_item].merge({
        client_id: @master_plan_item.client_id,
        project_id: @master_plan_item.project_id,
        master_plan_id: @master_plan_item.master_plan_id,
        spot_id: @master_plan_item.spot_id,
        medium_id: @master_plan_item.medium_id,
        channel_id: @master_plan_item.channel_id,
        version: @master_plan_item.master_plan.working_version
        }))
      @spot_plan_item.created_by_id = current_user.id
    end

    SpotPlanItem.transaction do
      @spot_plan_item.save!
      @spot_plan_item.master_plan.is_dirty = true
      @spot_plan_item.master_plan.save!
      respond_to do |format|
        format.json { render json: @spot_plan_item, status: :created, location: @spot_plan_item }
      end
    end
  end

  # PATCH/PUT /spot_plan_items/1
  # PATCH/PUT /spot_plan_items/1.json
  def update
    @spot_plan_item = SpotPlanItem.find(params[:id])

    SpotPlanItem.transaction do
      @spot_plan_item.update_attributes!(params[:spot_plan_item])
      @spot_plan_item.master_plan.is_dirty = true
      @spot_plan_item.master_plan.save!
      respond_to do |format|
        format.html { redirect_to spot_plan_item_path(@spot_plan_item), notice: 'Spot plan item was successfully updated.' }
        format.json { head :no_content }
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
        @new_spot_plan_item = @spot_plan_item.change_placed_at!(Time.parse(new_placed_at), current_user.id)
        @spot_plan_item.master_plan.is_dirty = true
        @spot_plan_item.master_plan.save!
        respond_to do |format|
          format.json { render json: @new_spot_plan_item }
        end
      end
    end
  end
end
