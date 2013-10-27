class MasterPlanItemsController < ApplicationController
  include ActionView::Helpers::NumberHelper

  # GET /master_plan_items
  # GET /master_plan_items.json
  def index
    @master_plan = MasterPlan.find params[:master_plan_id]
    if @master_plan.medium_master_plans.count > 0
      if params[:medium_id]
        @selected_medium_master_plan = @master_plan.medium_master_plans.where(medium_id: params[:medium_id]).first
      end
      @selected_medium_master_plan = @master_plan.medium_master_plans.first unless @selected_medium_master_plan
      @master_plan_items = @selected_medium_master_plan.master_plan_items.order('is_on_house, created_at')
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
        @master_plan_item.est_total_imp = @master_plan_item.est_imp * @master_plan_item.count if @master_plan_item.est_imp
        @master_plan_item.est_total_clicks = @master_plan_item.est_clicks * @master_plan_item.count if @master_plan_item.est_clicks
        @master_plan_item.est_ctr = @master_plan_item.est_clicks.to_f / @master_plan_item.est_imp.to_f if @master_plan_item.est_clicks && @master_plan_item.est_imp

        unless @master_plan_item.medium_net_cost
          @master_plan_item.medium_net_cost = @master_plan_item.unit_rate_card * @master_plan_item.count * @master_plan_item.medium_discount
        end

        unless @master_plan_item.company_net_cost
          @master_plan_item.company_net_cost = @master_plan_item.unit_rate_card * @master_plan_item.count * @master_plan_item.company_discount
        end

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
    client_id = @master_plan_item.client_id
    project_id = @master_plan_item.project_id
    @master_plan_item.destroy

    respond_to do |format|
      format.html { redirect_to client_project_master_plan_path(client_id: client_id, project_id: project_id, id: master_plan_id) }
      format.json { head :no_content }
    end
  end
end
