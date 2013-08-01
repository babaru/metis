class SpotCategoriesController < ApplicationController
  # GET /spot_categories
  # GET /spot_categories.json
  def index
    @spot_categories_grid = initialize_grid(SpotCategory)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @spot_categories_grid }
    end
  end

  # GET /spot_categories/1
  # GET /spot_categories/1.json
  def show
    @spot_category = SpotCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @spot_category }
    end
  end

  # GET /spot_categories/new
  # GET /spot_categories/new.json
  def new
    @spot_category = SpotCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @spot_category }
    end
  end

  # GET /spot_categories/1/edit
  def edit
    @spot_category = SpotCategory.find(params[:id])
  end

  # POST /spot_categories
  # POST /spot_categories.json
  def create
    @spot_category = SpotCategory.new(params[:spot_category])

    respond_to do |format|
      if @spot_category.save
        format.html { redirect_to spot_category_path(@spot_category), notice: 'Spot category was successfully created.' }
        format.json { render json: @spot_category, status: :created, location: @spot_category }
      else
        format.html { render action: "new" }
        format.json { render json: @spot_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /spot_categories/1
  # PATCH/PUT /spot_categories/1.json
  def update
    @spot_category = SpotCategory.find(params[:id])

    respond_to do |format|
      if @spot_category.update_attributes(params[:spot_category])
        format.html { redirect_to spot_category_path(@spot_category), notice: 'Spot category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @spot_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /spot_categories/1
  # DELETE /spot_categories/1.json
  def destroy
    @spot_category = SpotCategory.find(params[:id])
    @spot_category.destroy

    respond_to do |format|
      format.html { redirect_to spot_categories_url }
      format.json { head :no_content }
    end
  end
end