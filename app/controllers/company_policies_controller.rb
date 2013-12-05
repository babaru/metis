class CompanyPoliciesController < ApplicationController
  # GET /company_policies
  # GET /company_policies.json
  def index
    @client = Client.find params[:client_id]
    @company_policies_grid = initialize_grid(CompanyPolicy.where(client_id: @client.id))

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @company_policies_grid }
    end
  end

  # GET /company_policies/1
  # GET /company_policies/1.json
  def show
    @company_policy = CompanyPolicy.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @company_policy }
    end
  end

  # GET /company_policies/new
  # GET /company_policies/new.json
  def new
    @client = Client.find params[:client_id]
    @company_policy = CompanyPolicy.new
    @company_policy.client = @client

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @company_policy }
    end
  end

  # GET /company_policies/1/edit
  def edit
    @company_policy = CompanyPolicy.find(params[:id])
  end

  # POST /company_policies
  # POST /company_policies.json
  def create
    @company_policy = CompanyPolicy.new(params[:company_policy])

    respond_to do |format|
      if @company_policy.save
        format.html { redirect_to client_company_policies_path(client_id: @company_policy.client_id), notice: 'Company policy was successfully created.' }
        format.json { render json: @company_policy, status: :created, location: @company_policy }
      else
        format.html { render action: "new" }
        format.json { render json: @company_policy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /company_policies/1
  # PATCH/PUT /company_policies/1.json
  def update
    @company_policy = CompanyPolicy.find(params[:id])

    respond_to do |format|
      if @company_policy.update_attributes(params[:company_policy])
        format.html { redirect_to client_company_policies_path(client_id: @company_policy.client_id), notice: 'Company policy was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @company_policy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /company_policies/1
  # DELETE /company_policies/1.json
  def destroy
    @company_policy = CompanyPolicy.find(params[:id])
    client_id = @company_policy.client_id
    @company_policy.destroy

    respond_to do |format|
      format.html { redirect_to client_company_policies_path(client_id: client_id) }
      format.json { head :no_content }
    end
  end
end
