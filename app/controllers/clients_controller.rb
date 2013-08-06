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

  def discounts
    @client = Client.find(params[:id])

    if request.post?
      Website.all.each do |website|
        discount = 1
        if params[:client_discounts] && params[:client_discounts][website.id.to_s.to_sym]
          discount = params[:client_discounts][website.id.to_s.to_sym].to_f / 10
        end
        d = @client.discounts.where(website_id: website.id).first
        if d
          d.discount = discount
          d.save!
        else
          @client.discounts << ClientDiscount.new(client_id: @client.id, website_id: website.id, discount: discount)
        end
      end
      @client.save!

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @client }
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
      if @client.save
        format.html { redirect_to client_path(@client), notice: 'Client was successfully created.' }
        format.json { render json: @client, status: :created, location: @client }
      else
        format.html { render action: "new" }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
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
end
