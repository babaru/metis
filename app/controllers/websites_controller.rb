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

        Spot.transaction do
          Spreadsheet.open @upload_file.data_file.path do |book|
            sheet = book.worksheet(0)
            1.upto(sheet.last_row_index) do |index|
              channel_name = sheet.row(index)[0]
              channel = Channel.where(name: channel_name, website_id: @website.id).first
              if channel.nil?
                Rails.logger.error "Can not find channel named #{channel_name}"
                next
              end
              spot_spec = {}
              spec_text = sheet.row(index)[4]
              if spec_text
                spec_text = spec_text.gsub(/[;；]/, ';').strip
                specs = spec_text.split(';')
                spot_spec[:dimension] = specs[0]
                spot_spec[:size] = specs[1]
                spot_spec[:types] = specs[2].split('.')
              end
              spot_name = sheet.row(index)[1]
              spot = Spot.find_by_name_and_channel_id(spot_name, channel.id)
              if spot.nil?
                Spot.create!({
                  website_id: @website.id,
                  channel_id: channel.id,
                  name: sheet.row(index)[1],
                  price: sheet.row(index)[2],
                  unit: sheet.row(index)[3],
                  spec: spot_spec
                  })
              else
                spot.update_attributes!({
                  website_id: @website.id,
                  channel_id: channel.id,
                  name: sheet.row(index)[1],
                  price: sheet.row(index)[2],
                  unit: sheet.row(index)[3],
                  spec: spot_spec
                  })
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
