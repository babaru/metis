class SpacesController < ApplicationController
  # GET /spaces
  # GET /spaces.json
  def index
    @spaces_grid = initialize_grid(Space)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @spaces_grid }
    end
  end

  # GET /spaces/1
  # GET /spaces/1.json
  def show
    @space = Space.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @space }
    end
  end

  # GET /spaces/new
  # GET /spaces/new.json
  def new
    @space = Space.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @space }
    end
  end

  # GET /spaces/1/edit
  def edit
    @space = Space.find(params[:id])
  end

  # POST /spaces
  # POST /spaces.json
  def create
    @space = Space.new(params[:space])

    respond_to do |format|
      if @space.save
        format.html { redirect_to assign_space_user_path(@space), notice: 'Space was successfully created.' }
        format.json { render json: @space, status: :created, location: @space }
      else
        format.html { render action: "new" }
        format.json { render json: @space.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /spaces/1
  # PATCH/PUT /spaces/1.json
  def update
    @space = Space.find(params[:id])

    respond_to do |format|
      if @space.update_attributes(params[:space])
        format.html { redirect_to spaces_path, notice: 'Space was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @space.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /spaces/1
  # DELETE /spaces/1.json
  def destroy
    @space = Space.find(params[:id])
    @space.destroy

    respond_to do |format|
      format.html { redirect_to spaces_url }
      format.json { head :no_content }
    end
  end

  def assign_user
    @space = Space.find params[:id]
  end

  def save_user_assignments
    @space = Space.find(params[:id])
    if request.post?
      respond_to do |format|
        if @space.update_attributes(params[:space])
          format.html { redirect_to spaces_path, notice: "#{SpaceUser.model_name.human}保存成功！" }
          format.json { head :no_content }
        else
          format.html { render action: "assign" }
          format.json { render json: @space.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def assign_client
    @space = Space.find params[:id]
  end

  def save_client_assignments
    @space = Space.find(params[:id])
    if request.post?
      respond_to do |format|
        if @space.update_attributes(params[:space])
          format.html { redirect_to spaces_path, notice: "公司客户保存成功！" }
          format.json { head :no_content }
        else
          format.html { render action: "assign" }
          format.json { render json: @space.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def switch
    session[:space_id] = params[:id]
    redirect_to dashboard_path
  end

end
