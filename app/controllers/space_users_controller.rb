class SpaceUsersController < ApplicationController
  # GET /space_users
  # GET /space_users.json
  def index
    @space_users_grid = initialize_grid(SpaceUser)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @space_users_grid }
    end
  end

  # GET /space_users/1
  # GET /space_users/1.json
  def show
    @space_user = SpaceUser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @space_user }
    end
  end

  # GET /space_users/new
  # GET /space_users/new.json
  def new
    @space_user = SpaceUser.new
    @space_user.space_id = current_space.id
    @space_user.user_id = params[:user_id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @space_user }
    end
  end

  # GET /space_users/1/edit
  def edit
    @space_user = SpaceUser.find(params[:id])
  end

  # POST /space_users
  # POST /space_users.json
  def create
    @space_user = SpaceUser.new(params[:space_user])

    respond_to do |format|
      if @space_user.save
        format.html { redirect_to space_users_path, notice: 'Space user was successfully created.' }
        format.json { render json: @space_user, status: :created, location: @space_user }
      else
        format.html { render action: "new" }
        format.json { render json: @space_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /space_users/1
  # PATCH/PUT /space_users/1.json
  def update
    @space_user = SpaceUser.find(params[:id])

    respond_to do |format|
      if @space_user.update_attributes(params[:space_user])
        format.html { redirect_to space_users_path, notice: 'Space user was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @space_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /space_users/1
  # DELETE /space_users/1.json
  def destroy
    @space_user = SpaceUser.find(params[:id])
    @space_user.destroy

    respond_to do |format|
      format.html { redirect_to space_users_url }
      format.json { head :no_content }
    end
  end

  def assign_space_user_roles
    @space_user = SpaceUser.find params[:id]
  end

  def save_space_user_roles
    @space_user = SpaceUser.find params[:id]
    if request.post?
      @space_user.update_attributes(params[:space_user])
      redirect_to users_path, notice: '用户权限成功更新'
    end
  end
end
