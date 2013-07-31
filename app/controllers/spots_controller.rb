#encoding: utf-8
class SpotsController < ApplicationController
  # GET /spots
  # GET /spots.json
  def index
    @websites = Website.all
    @website = Website.find params[:website_id]
    @spot_categories = @website.spot_categories
    @spot_category = SpotCategory.find params[:spot_category_id] if params[:spot_category_id]
    @spot_category = @spot_categories.first if @spot_category.nil?
    if @spot_category
      @spots_grid = initialize_grid(Spot.where(website_id: @website.id, spot_category_id: @spot_category.id))
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json
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

  def upload
    @website = Website.find params[:website_id]
    @upload_file = SpotDataFile.new
    @upload_file.website_id = @website.id
    Rails.logger.debug "meta_data: #{@upload_file.meta_data}"

    if request.post?
      @upload_file = SpotDataFile.new(params[:spot_data_file])
      Rails.logger.debug "meta_data: #{@upload_file.meta_data}"
      @upload_file.save!

      spot_categories_data = @upload_file.parse(@website.id)

      SpotCategory.transaction do
        spot_categories_data.each do |spot_category_data|
          spot_category = SpotCategory.find_or_create_by_data!(spot_category_data)
          filled_channel_ids = []
          spot_category_data[:spots].each do |spot_data|
            the_other_channels = false
            group_name = spot_data[:channel_name]
            group_name.scan(/(.+)其他/) do |matches|
              the_other_channels = true if matches.length > 0
              group_name = matches[0]
            end

            channel_group = ChannelGroup.find_by_name_and_website_id(group_name, spot_data[:website_id])
            if channel_group
              Rails.logger.debug group_name
              channels = []
              if the_other_channels
                channels = channel_group.reset_channels(filled_channel_ids)
              else
                channels = channel_group.channels
              end
              channels.each do |ch|
                spot_data = spot_data.merge({
                channel_id: ch.id,
                spot_category_id: spot_category.id
                })

                Spot.find_or_create_by_data!(spot_data)
              end
            else
              channel = Channel.find_or_create_by_data!({
                name: spot_data[:channel_name],
                website_id: spot_data[:website_id]
                })
              spot_data = spot_data.merge({
                channel_id: channel.id,
                spot_category_id: spot_category.id
                })

              Spot.find_or_create_by_data!(spot_data)
              filled_channel_ids << channel.id unless filled_channel_ids.include? channel.id
            end
          end
        end
      end

      respond_to do |format|
        format.html { redirect_to website_spots_path(@website), notice: 'Spots were successfully uploaded' }
      end
    end
  end
end
