#encoding: utf-8
class SpotsController < ApplicationController
  # GET /spots
  # GET /spots.json
  def index
    @media = Medium.all
    @spot_picker = Tida::Metis::SpotPicker.new params
    @spots_grid = initialize_grid(Spot.where(@spot_picker.spots_query_clause), name: 'spot_candidates_grid') if @spot_picker.selected_medium

    respond_to do |format|
      format.html
      format.json
    end
  end

  def apps
    @platform = 'ios'
    @platform = params[:platform] if params[:platform]
    Feedzirra::Feed.add_common_feed_entry_element('im:image', as: :image)
    @feed = Feedzirra::Feed.fetch_and_parse("https://itunes.apple.com/cn/rss/topfreeapplications/limit=100/xml")
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
    @medium_id = params[:medium_id]
    @spot.medium_id = @medium_id
    @spot.spot_category_id = params[:spot_category_id]
    @spot.type = 'Spot'

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @spot }
    end
  end

  # GET /spots/1/edit
  def edit
    @spot = Spot.find(params[:id])
    @medium = @spot.medium
  end

  # POST /spots
  # POST /spots.json
  def create
    @spot = Spot.new(params[:spot])

    respond_to do |format|
      if @spot.save
        format.html { redirect_to medium_spots_path(medium_id: @spot.medium_id, spot_category_id: @spot.spot_category_id), notice: 'Spot was successfully created.' }
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
        format.html { redirect_to medium_spots_path(medium_id: @spot.medium_id, spot_category_id: @spot.spot_category_id), notice: 'Spot was successfully updated.' }
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
    @medium_id = @spot.medium_id
    @spot_category_id = @spot.spot_category_id
    @spot.destroy

    respond_to do |format|
      format.html { redirect_to medium_spots_path(medium_id: @medium_id, spot_category_id: @spot_category_id) }
      format.json { head :no_content }
    end
  end

  def upload
    @medium = Medium.find params[:medium_id]
    @upload_file = SpotDataFile.new
    @upload_file.medium_id = @medium.id
    Rails.logger.debug "meta_data: #{@upload_file.meta_data}"

    if request.post?
      @upload_file = SpotDataFile.new(params[:spot_data_file])
      Rails.logger.debug "meta_data: #{@upload_file.meta_data}"
      @upload_file.save!

      spot_categories_data = @upload_file.parse(@medium.id)

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

            channel_group = ChannelGroup.find_by_name_and_medium_id(group_name, spot_data[:medium_id])
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
                medium_id: spot_data[:medium_id]
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
        format.html { redirect_to medium_spots_path(@medium), notice: 'Spots were successfully uploaded' }
      end
    end
  end
end
