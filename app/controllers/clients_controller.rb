class ClientsController < ApplicationController
  # GET /clients
  # GET /clients.json
  def index
    @clients = current_user.viewable_clients

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @clients_grid }
    end
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
    @client = Client.find(params[:id])
    @users = @client.assigned_users
    if current_user.has_role? :admin
      @projects_grid = initialize_grid(Project.where(client_id: @client.id))
    else
      @projects_grid = initialize_grid(Project.joins('left outer join project_assignments on project_assignments.project_id=projects.id').where('client_id=? and project_assignments.user_id=?', @client.id, current_user.id))
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @client }
    end
  end

  def assign
    @client = Client.find(params[:id])
  end

  def view_medium_policies
    @client = Client.find params[:id]
  end

  def medium_policies
    @client = Client.find params[:id]

    if request.post?
      params[:medium_ids].each_with_index do |medium_id, index|
        medium_discount = 1
        company_discount = 1
        medium_bonus_ratio = 0
        company_bonus_ratio = 0
        medium_cpm_discount = 1
        company_cpm_discount = 1

        medium_discount = params[:medium_discounts][index]
        company_discount = params[:company_discounts][index]
        medium_bonus_ratio = params[:medium_bonus_ratios][index]
        company_bonus_ratio = params[:company_bonus_ratios][index]
        medium_cpm_discount = params[:medium_cpm_discounts][index]
        company_cpm_discount = params[:company_cpm_discounts][index]

        @medium_policy = MediumPolicy.find_by_medium_id_and_client_id(medium_id, @client.id)
        if @medium_policy
          @medium_policy.medium_discount = medium_discount
          @medium_policy.company_discount = company_discount
          @medium_policy.medium_bonus_ratio = medium_bonus_ratio
          @medium_policy.company_bonus_ratio = company_bonus_ratio
          @medium_policy.medium_cpm_discount = medium_cpm_discount
          @medium_policy.company_cpm_discount = company_cpm_discount
          @medium_policy.save!
        else
          @medium_policy = MediumPolicy.create!({
            client_id: @client.id,
            medium_id: medium_id,
            medium_discount: medium_discount,
            company_discount: company_discount,
            medium_bonus_ratio: medium_bonus_ratio,
            company_bonus_ratio: company_bonus_ratio,
            medium_cpm_discount: medium_cpm_discount,
            company_cpm_discount: company_cpm_discount
            })
        end
      end

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @medium_policy }
      end
    end
  end

  # GET /clients/new
  # GET /clients/new.json
  def new
    @client = Client.new
    @client.created_by_id = current_user.id

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @client }
    end
  end

  # GET /clients/1/edit
  def edit
    @client = Client.find(params[:id])
  end

  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(params[:client])

    respond_to do |format|
      Client.transaction do
        @client.save!
        Medium.all.each do |medium|
          MediumPolicy.create!({
            medium_id: medium.id,
            client_id: @client.id,
            medium_discount: 1,
            company_discount: 1,
            medium_bonus_ratio: 0,
            company_bonus_ratio: 0,
            medium_cpm_discount: 1,
            company_cpm_discount: 1
            }) unless MediumPolicy.exists?(client_id: @client.id, medium_id: medium.id)
        end
        format.html { redirect_to client_path(@client), notice: 'Client was successfully created.' }
        format.json { render json: @client, status: :created, location: @client }
      end
      # else
        # format.html { render action: "new" }
        # format.json { render json: @client.errors, status: :unprocessable_entity }
      # end
    end
  end

  # PATCH/PUT /clients/1
  # PATCH/PUT /clients/1.json
  def update
    @client = Client.find(params[:id])

    respond_to do |format|
      if @client.update_attributes(params[:client])
        format.html { redirect_to client_path(@client), notice: 'Client was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    @client = Client.find(params[:id])
    @client.destroy

    respond_to do |format|
      format.html { redirect_to clients_url }
      format.json { head :no_content }
    end
  end

  def upload_spot_plan_excel_file
    @client = Client.find params[:id]
    @upload_file = SpotPlanExcelFile.new
    if request.post?
      @upload_file = SpotPlanExcelFile.new(params[:spot_plan_excel_file])
      @upload_file.save!
      @upload_file.parse!(@client.id, current_user.id)
    end
  end
end
