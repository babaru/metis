class MediumPoliciesController < ApplicationController
  # GET /medium_policies
  # GET /medium_policies.json
  def index
    @medium_policies_grid = initialize_grid(MediumPolicy)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @medium_policies_grid }
    end
  end

  # GET /medium_policies/1
  # GET /medium_policies/1.json
  def show
    @medium_policy = MediumPolicy.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @medium_policy }
    end
  end

  # GET /medium_policies/new
  # GET /medium_policies/new.json
  def new
    @medium_policy = MediumPolicy.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @medium_policy }
    end
  end

  # GET /medium_policies/1/edit
  def edit
    @medium_policy = MediumPolicy.find(params[:id])
  end

  # POST /medium_policies
  # POST /medium_policies.json
  def create
    @medium_policy = MediumPolicy.new(params[:medium_policy])

    respond_to do |format|
      if @medium_policy.save
        format.html { redirect_to medium_policy_path(@medium_policy), notice: 'Medium policy was successfully created.' }
        format.json { render json: @medium_policy, status: :created, location: @medium_policy }
      else
        format.html { render action: "new" }
        format.json { render json: @medium_policy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /medium_policies/1
  # PATCH/PUT /medium_policies/1.json
  def update
    @medium_policy = MediumPolicy.find(params[:id])

    respond_to do |format|
      if @medium_policy.update_attributes(params[:medium_policy])
        format.html { redirect_to medium_policy_path(@medium_policy), notice: 'Medium policy was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @medium_policy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /medium_policies/1
  # DELETE /medium_policies/1.json
  def destroy
    @medium_policy = MediumPolicy.find(params[:id])
    @medium_policy.destroy

    respond_to do |format|
      format.html { redirect_to medium_policies_url }
      format.json { head :no_content }
    end
  end
end
