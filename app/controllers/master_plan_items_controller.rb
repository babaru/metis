class MasterPlanItemsController < ApplicationController
  # GET /master_plan_items
  # GET /master_plan_items.json
  def index
    @master_plan_items_grid = initialize_grid(MasterPlanItem)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @master_plan_items_grid }
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
