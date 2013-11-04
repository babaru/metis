class MediaController < ApplicationController
  add_breadcrumb(I18n.t('model.list', model: Medium.model_name.human), nil, only: :index)

  # GET /media
  # GET /media.json
  def index
    @media_grid = initialize_grid(Medium)
    @media = Medium.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @media_grid }
    end
  end

  # GET /media/1
  # GET /media/1.json
  def show
    redirect_to medium_channel_groups_path(params[:id])
  end

  # GET /media/new
  # GET /media/new.json
  def new
    @medium = Medium.new
    @medium.type = 'Medium'

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @medium }
    end
  end

  # GET /media/1/edit
  def edit
    @medium = Medium.find(params[:id])
  end

  # POST /media
  # POST /media.json
  def create
    @medium = Medium.new(params[:medium])

    respond_to do |format|
      Medium.transaction do
        @medium.save!
      # if @medium.save
        Client.all.each do |client|
          MediumPolicy.create!({
            medium_id: @medium.id,
            client_id: client.id,
            medium_discount: 1,
            company_discount: 1,
            medium_bonus_ratio: 0,
            company_bonus_ratio: 0,
            medium_cpm_discount: 1,
            company_cpm_discount: 1
            }) unless MediumPolicy.exists?(client_id: client.id, medium_id: @medium.id)
        end
        format.html { redirect_to media_path(), notice: 'Medium was successfully created.' }
        format.json { render json: @medium, status: :created, location: @medium }
      end
      # else
        # format.html { render action: "new" }
        # format.json { render json: @medium.errors, status: :unprocessable_entity }
      # end
    end
  end

  # PATCH/PUT /media/1
  # PATCH/PUT /media/1.json
  def update
    @medium = Medium.find(params[:id])

    respond_to do |format|
      if @medium.update_attributes(params[:medium])
        format.html { redirect_to media_path(), notice: 'Medium was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @medium.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /media/1
  # DELETE /media/1.json
  def destroy
    @medium = Medium.find(params[:id])
    @medium.destroy

    respond_to do |format|
      format.html { redirect_to media_url }
      format.json { head :no_content }
    end
  end

  def upload_data_file
    @data_type = params[:data_type]
    @medium = Medium.find params[:id]

    if @data_type == 'spot'
      @upload_file = SpotDataFile.new
      @upload_file.medium_id = @medium.id
      Rails.logger.debug "meta_data: #{@upload_file.meta_data}"
    end

    if request.post?
      if @data_type == 'spot'
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
      end
    end
  end

  def search
    @medium = Medium.find params[:id]
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
