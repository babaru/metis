class CompanyPolicyItemsController < ApplicationController
  # GET /company_policy_items
  # GET /company_policy_items.json
  def index
    @company_policy = CompanyPolicy.find params[:company_policy_id]
    @company_policy_items_grid = initialize_grid(CompanyPolicyItem)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @company_policy_items_grid }
    end
  end

  # GET /company_policy_items/1
  # GET /company_policy_items/1.json
  def show
    @company_policy_item = CompanyPolicyItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @company_policy_item }
    end
  end

  # GET /company_policy_items/new
  # GET /company_policy_items/new.json
  def new
    @company_policy = CompanyPolicy.find params[:company_policy_id]
    @company_policy_item = CompanyPolicyItem.new
    @company_policy_item.company_policy = @company_policy

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @company_policy_item }
    end
  end

  # GET /company_policy_items/1/edit
  def edit
    @company_policy_item = CompanyPolicyItem.find(params[:id])
  end

  # POST /company_policy_items
  # POST /company_policy_items.json
  def create
    @company_policy_item = CompanyPolicyItem.new(params[:company_policy_item])

    respond_to do |format|
      if @company_policy_item.save
        format.html { redirect_to client_company_policy_company_policy_items_path(client_id: @company_policy_item.company_policy.client_id, company_policy_id: @company_policy_item.company_policy_id), notice: 'Company policy item was successfully created.' }
        format.json { render json: @company_policy_item, status: :created, location: @company_policy_item }
      else
        format.html { render action: "new" }
        format.json { render json: @company_policy_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /company_policy_items/1
  # PATCH/PUT /company_policy_items/1.json
  def update
    @company_policy_item = CompanyPolicyItem.find(params[:id])

    respond_to do |format|
      if @company_policy_item.update_attributes(params[:company_policy_item])
        format.html { redirect_to client_company_policy_company_policy_items_path(client_id: @company_policy_item.company_policy.client_id, company_policy_id: @company_policy_item.company_policy_id), notice: 'Company policy item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @company_policy_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /company_policy_items/1
  # DELETE /company_policy_items/1.json
  def destroy
    @company_policy_item = CompanyPolicyItem.find(params[:id])
    company_policy = @company_policy_item.company_policy
    @company_policy_item.destroy

    respond_to do |format|
      format.html { redirect_to client_company_policy_company_policy_items_path(client_id: company_policy.client_id, company_policy_id: company_policy_id) }
      format.json { head :no_content }
    end
  end
end
