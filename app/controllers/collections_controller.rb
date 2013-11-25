class CollectionsController < ApplicationController
  # GET /collections
  # GET /collections.json
  def index
    @collections_grid = initialize_grid(Collection)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @collections_grid }
    end
  end

  # GET /collections/1
  # GET /collections/1.json
  def show
    @collection = Collection.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @collection }
    end
  end

  # GET /collections/new
  # GET /collections/new.json
  def new
    @collection = Collection.new
    @project = Project.find params[:project_id]
    @collection.project = @project
    @collection.client_id = @project.client_id
    @collection.space = current_space

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @collection }
    end
  end

  # GET /collections/1/edit
  def edit
    @collection = Collection.find(params[:id])
  end

  # POST /collections
  # POST /collections.json
  def create
    @collection = Collection.new(params[:collection])

    respond_to do |format|
      if @collection.save
        format.html { redirect_to collections_path, notice: 'Collection was successfully created.' }
        format.json { render json: @collection, status: :created, location: @collection }
      else
        format.html { render action: "new" }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /collections/1
  # PATCH/PUT /collections/1.json
  def update
    @collection = Collection.find(params[:id])

    respond_to do |format|
      if @collection.update_attributes(params[:collection])
        format.html { redirect_to collections_path, notice: 'Collection was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /collections/1
  # DELETE /collections/1.json
  def destroy
    @collection = Collection.find(params[:id])
    @collection.destroy

    respond_to do |format|
      format.html { redirect_to collections_url }
      format.json { head :no_content }
    end
  end

  def assign_invoice
    @collection = Collection.find params[:id]
  end

  def save_invoice_assignment
    @collection = Collection.find params[:id]
    if request.post?
      @collection.update_attributes!(params[:collection])
      respond_to do |format|
        format.html { redirect_to collections_path, notice: '发票绑定完毕'}
      end
    end
  end
end
