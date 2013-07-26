#encoding: utf-8
class WebsitesController < ApplicationController
  # GET /websites
  # GET /websites.json
  def index
    @websites_grid = initialize_grid(Website)
    @websites = Website.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @websites_grid }
    end
  end

  # GET /websites/1
  # GET /websites/1.json
  def show
    @website = Website.find(params[:id])
    @data_type = params[:data_type]
    if @data_type == 'spot'
      @spots_grid = initialize_grid(Spot.where(website_id: @website.id).order('channel_id, name'))
    else
      @channels_grid = initialize_grid(Channel.where(website_id: @website.id))
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @website }
    end
  end

  # GET /websites/new
  # GET /websites/new.json
  def new
    @website = Website.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @website }
    end
  end

  # GET /websites/1/edit
  def edit
    @website = Website.find(params[:id])
  end

  # POST /websites
  # POST /websites.json
  def create
    @website = Website.new(params[:website])

    respond_to do |format|
      if @website.save
        format.html { redirect_to websites_path(), notice: 'Website was successfully created.' }
        format.json { render json: @website, status: :created, location: @website }
      else
        format.html { render action: "new" }
        format.json { render json: @website.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /websites/1
  # PATCH/PUT /websites/1.json
  def update
    @website = Website.find(params[:id])

    respond_to do |format|
      if @website.update_attributes(params[:website])
        format.html { redirect_to websites_path(), notice: 'Website was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @website.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /websites/1
  # DELETE /websites/1.json
  def destroy
    @website = Website.find(params[:id])
    @website.destroy

    respond_to do |format|
      format.html { redirect_to websites_url }
      format.json { head :no_content }
    end
  end

  def upload_data_file
    @data_type = params[:data_type]
    @website = Website.find params[:id]

    if @data_type == 'spot'
      @upload_file = SpotDataFile.new
      @upload_file.website_id = @website.id
      Rails.logger.debug "meta_data: #{@upload_file.meta_data}"
    end

    if request.post?
      if @data_type == 'spot'
        @upload_file = SpotDataFile.new(params[:spot_data_file])
        Rails.logger.debug "meta_data: #{@upload_file.meta_data}"
        @upload_file.save!

        spot_categories_data = @upload_file.parse(@website.id)

        SpotCategory.transaction do
          spot_categories_data.each do |spot_category_data|
            spot_category = SpotCategory.find_or_create_by_data!(spot_category_data)
            filled_channels = []
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
                channels = nil
                if the_other_channels
                  channels = channel_group.reset_channels(filled_channels)
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
                filled_channels << channel
              end
            end
          end
        end
      end
    end
  end

  def search
    @website = Website.find params[:id]
    @data_type = params[:data_type]

    if request.post?
      if @data_type == 'spot'
        @spots_grid = initialize_grid(Spot.where("name like '%#{params[:keywords]}%'"))
        respond_to do |format|
          format.js
        end
      end
    end
  end
end
