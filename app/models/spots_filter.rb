#encoding: utf-8

class SpotsFilter
  attr_reader :selected_medium, :selected_channel, :selected_spot_category, :selected_unit_type, :selected_spots, :selected_unit_type_name
  attr_reader :spots_query_clause
  attr_reader :unit_types
  attr_reader :spot_categories
  attr_reader :channels
  attr_reader :filter_params

  def initialize(options)
    unit_type_query_string = nil
    if options[:medium_id]
      @selected_medium = Medium.find options[:medium_id]
      @channels = @selected_medium.channels
      unit_type_query_string = "medium_id = #{@selected_medium.id}"
    end

    if options[:channel_id]
      @selected_channel = Channel.find options[:channel_id]
      unit_type_query_string = "#{unit_type_query_string} and channel_id=#{@selected_channel.id}"
    end

    @selected_unit_type = options[:unit_type] if options[:unit_type]
    @unit_types = ['day', 'cpm', 'cpc']

    where_clause = []
    where_clause << "medium_id=#{@selected_medium.id}" if @selected_medium
    where_clause << "channel_id=#{@selected_channel.id}" if @selected_channel

    if @selected_unit_type
      if @selected_unit_type == 'day'
        where_clause << "unit like '%天%'"
      elsif @selected_unit_type == 'cpm'
        where_clause << "(unit like '%CPM%' or unit like '%cpm%')"
      elsif @selected_unit_type == 'cpc'
        where_clause << "(unit like '%CPC%' or unit like '%CPC%')"
      end

      @selected_unit_type_name = I18n.t("activerecord.attributes.spot.unit_type.#{@selected_unit_type}")
    end

    @spot_categories = @selected_medium.spot_categories if @selected_medium
    @selected_spot_category = SpotCategory.find options[:spot_category_id] if options[:spot_category_id]

    if @selected_spot_category
      where_clause << "spot_category_id=#{@selected_spot_category.id}"
    end

    @spots_query_clause = where_clause.join(' and ')
    @filter_params = {}
    @filter_params[:medium_id] = @selected_medium.id if @selected_medium
    @filter_params[:channel_id] = @selected_channel.id if @selected_channel
    @filter_params[:spot_category_id] = @selected_spot_category.id if @selected_spot_category
    @filter_params[:unit_type] = @selected_unit_type if @selected_unit_type
    Rails.logger.debug @filter_params
  end
end
