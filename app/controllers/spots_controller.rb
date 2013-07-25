#encoding: utf-8
class SpotsController < ApplicationController
  # GET /spots
  # GET /spots.json
  def index
    @websites = Website.all

    unit_type_query_string = nil
    if params[:website_id]
      @selected_website = Website.find params[:website_id]
      @channels = @selected_website.channels
      unit_type_query_string = "website_id = #{@selected_website.id}"
    end

    if params[:channel_id]
      @selected_channel = Channel.find params[:channel_id]
      unit_type_query_string = "#{unit_type_query_string} and channel_id=#{@selected_channel.id}"
    end

    @selected_unit_type = params[:unit_type] if params[:unit_type]

    if unit_type_query_string.nil?
      @unit_types = ['day', 'cpm', 'cpc']
    else
      @unit_types = []
      if Spot.count("#{unit_type_query_string} and unit like '%天%'") > 0
        @unit_types << 'day'
      elsif Spot.count("#{unit_type_query_string} and (unit like '%CPM%' or unit like '%cpm%')") > 0
        @unit_types << 'cpm'
      elsif Spot.count("#{unit_type_query_string} and (unit like '%CPC%' or unit like '%cpc%')") > 0
        @unit_types << 'cpc'
      end
    end

    where_clause = []
    where_clause << "website_id=#{@selected_website.id}" if @selected_website
    where_clause << "channel_id=#{@selected_channel.id}" if @selected_channel

    if @selected_unit_type
      if @selected_unit_type == 'day'
        where_clause << "unit like '%天%'"
      elsif @selected_unit_type == 'cpm'
        where_clause << "(unit like '%CPM%' or unit like '%cpm%')"
      elsif @selected_unit_type == 'cpc'
        where_clause << "(unit like '%CPC%' or unit like '%CPC%')"
      end
    end


    @spots_grid = initialize_grid(Spot.where(where_clause.join(' and ')))

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @spots_grid }
    end
  end

  # GET /spots/1
  # GET /spots/1.json
  def show
    @spot = Spot.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @spot }
    end
  end

  # GET /spots/new
  # GET /spots/new.json
  def new
    @spot = Spot.new
    @website = Website.find params[:website_id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @spot }
    end
  end

  # GET /spots/1/edit
  def edit
    @spot = Spot.find(params[:id])
  end

  # POST /spots
  # POST /spots.json
  def create
    @spot = Spot.new(params[:spot])

    respond_to do |format|
      if @spot.save
        format.html { redirect_to spot_path(@spot), notice: 'Spot was successfully created.' }
        format.json { render json: @spot, status: :created, location: @spot }
      else
        format.html { render action: "new" }
        format.json { render json: @spot.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /spots/1
  # PATCH/PUT /spots/1.json
  def update
    @spot = Spot.find(params[:id])

    respond_to do |format|
      if @spot.update_attributes(params[:spot])
        format.html { redirect_to spot_path(@spot), notice: 'Spot was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @spot.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /spots/1
  # DELETE /spots/1.json
  def destroy
    @spot = Spot.find(params[:id])
    @spot.destroy

    respond_to do |format|
      format.html { redirect_to spots_url }
      format.json { head :no_content }
    end
  end
end
