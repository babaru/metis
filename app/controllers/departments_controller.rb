class DepartmentsController < ApplicationController
  # GET /departments
  # GET /departments.json
  def index
    @departments_grid = initialize_grid(Department.where(space_id: current_space.id))

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @departments_grid }
    end
  end

  # GET /departments/1
  # GET /departments/1.json
  def show
    @department = Department.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @department }
    end
  end

  # GET /departments/new
  # GET /departments/new.json
  def new
    @department = Department.new
    @department.space = current_space

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @department }
    end
  end

  # GET /departments/1/edit
  def edit
    @department = Department.find(params[:id])
  end

  # POST /departments
  # POST /departments.json
  def create
    @department = Department.new(params[:department])

    respond_to do |format|
      if @department.save
        format.html { redirect_to departments_path, notice: 'Department was successfully created.' }
        format.json { render json: @department, status: :created, location: @department }
      else
        format.html { render action: "new" }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /departments/1
  # PATCH/PUT /departments/1.json
  def update
    @department = Department.find(params[:id])

    respond_to do |format|
      if @department.update_attributes(params[:department])
        format.html { redirect_to departments_path, notice: 'Department was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /departments/1
  # DELETE /departments/1.json
  def destroy
    @department = Department.find(params[:id])
    @department.destroy

    respond_to do |format|
      format.html { redirect_to departments_url }
      format.json { head :no_content }
    end
  end

  def assign_permissions
    @department = Department.find params[:id]
  end

  def save_department_permissions
    @department = Department.find params[:id]

    if request.post?
      @department.update_attributes!(params[:department])
      redirect_to departments_path, notice: '权限设置完毕'
    end
  end

  def assign_users
    @department = Department.find params[:id]
  end

  def save_department_users
    @department = Department.find params[:id]

    if request.post?
      @department.update_attributes!(params[:department])
      redirect_to departments_path, notice: '成员设置完毕'
    end
  end
end
