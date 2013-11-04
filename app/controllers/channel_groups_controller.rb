class ChannelGroupsController < ApplicationController
  add_breadcrumb(I18n.t('model.list', model: Medium.model_name.human), :media_path)

  # GET /channel_groups
  # GET /channel_groups.json
  def index
    @medium = Medium.find params[:medium_id]
    @channel_groups_grid = initialize_grid(ChannelGroup.where(medium_id: @medium))

    add_breadcrumb("#{@medium.name}#{t('model.list', model: ChannelGroup.model_name.human)}")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @channel_groups_grid }
    end
  end

  # GET /channel_groups/1
  # GET /channel_groups/1.json
  def show
    @channel_group = ChannelGroup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @channel_group }
    end
  end

  # GET /channel_groups/new
  # GET /channel_groups/new.json
  def new
    @channel_group = ChannelGroup.new
    @channel_group.medium_id = params[:medium_id]
    @medium = Medium.find params[:medium_id]
    @channels = @medium.channels

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @channel_group }
    end
  end

  # GET /channel_groups/1/edit
  def edit
    @channel_group = ChannelGroup.find(params[:id])
    @medium = @channel_group.medium
    @channels = @medium.channels
  end

  # POST /channel_groups
  # POST /channel_groups.json
  def create
    @channel_group = ChannelGroup.new(params[:channel_group])

    respond_to do |format|
      if @channel_group.save
        format.html { redirect_to medium_channel_groups_path(@channel_group.medium_id), notice: 'Channel group was successfully created.' }
        format.json { render json: @channel_group, status: :created, location: @channel_group }
      else
        format.html { render action: "new" }
        format.json { render json: @channel_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /channel_groups/1
  # PATCH/PUT /channel_groups/1.json
  def update
    @channel_group = ChannelGroup.find(params[:id])

    respond_to do |format|
      if @channel_group.update_attributes(params[:channel_group])
        format.html { redirect_to medium_channel_groups_path(@channel_group.medium_id), notice: 'Channel group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @channel_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /channel_groups/1
  # DELETE /channel_groups/1.json
  def destroy
    @channel_group = ChannelGroup.find(params[:id])
    @channel_group.destroy

    respond_to do |format|
      format.html { redirect_to channel_groups_url }
      format.json { head :no_content }
    end
  end
end
