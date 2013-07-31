class ChannelsController < ApplicationController
  # GET /channels
  # GET /channels.json
  def index
    @website = Website.find(params[:website_id])
    @channels_grid = initialize_grid(Channel.where(website_id: params[:website_id]))

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @channels_grid }
    end
  end

  # GET /channels/1
  # GET /channels/1.json
  def show
    @channel = Channel.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @channel }
    end
  end

  # GET /channels/new
  # GET /channels/new.json
  def new
    @channel = Channel.new
    @channel.website_id = params[:website_id]
    @website = Website.find params[:website_id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @channel }
    end
  end

  # GET /channels/1/edit
  def edit
    @channel = Channel.find(params[:id])
    @website = @channel.website
  end

  # POST /channels
  # POST /channels.json
  def create
    @channel = Channel.new(params[:channel])
    @channels = []
    trans_commit = false
    Channel.transaction do
      @channel.names.gsub(/\r\n/, '\n').split('\n').each_with_index do |line, index|
        channel = Channel.find_or_create_by_data!({
          name: line,
          website_id: @channel.website_id
          })
        @channels << channel
      end
      trans_commit = true
    end

    respond_to do |format|
      if trans_commit
        format.html { redirect_to website_channels_path(@channel.website_id), notice: 'Channel(s) was successfully created.' }
        # format.json { render json: @channels, status: :created, location: @channel }
      else
        format.html { render action: "new" }
        # format.json { render json: @channel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /channels/1
  # PATCH/PUT /channels/1.json
  def update
    @channel = Channel.find(params[:id])

    respond_to do |format|
      if @channel.update_attributes(params[:channel])
        format.html { redirect_to website_data_path(@channel.website_id, 'channel'), notice: 'Channel was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @channel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /channels/1
  # DELETE /channels/1.json
  def destroy
    @channel = Channel.find(params[:id])
    website_id = @channel.website_id
    @channel.destroy

    respond_to do |format|
      format.html { redirect_to website_channels_path(website_id) }
      format.json { head :no_content }
    end
  end
end
