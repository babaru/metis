#encoding: utf-8

class SpotsFilter
  attr_reader :selected_website, :selected_channel, :selected_spot_category, :selected_unit_type, :selected_spots, :selected_unit_type_name
  attr_reader :spots_query_clause
  attr_reader :unit_types
  attr_reader :spot_categories
  attr_reader :channels
  attr_reader :filter_params

  def initialize(options)
    unit_type_query_string = nil
    if options[:website_id]
      @selected_website = Website.find options[:website_id]
      @channels = @selected_website.channels
      unit_type_query_string = "website_id = #{@selected_website.id}"
    end

    if options[:channel_id]
      @selected_channel = Channel.find options[:channel_id]
      unit_type_query_string = "#{unit_type_query_string} and channel_id=#{@selected_channel.id}"
    end

    @selected_unit_type = options[:unit_type] if options[:unit_type]
    @unit_types = ['day', 'cpm', 'cpc']

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

      @selected_unit_type_name = I18n.t("activerecord.attributes.spot.unit_type.#{@selected_unit_type}")
    end

    @spot_categories = @selected_website.spot_categories if @selected_website
    @selected_spot_category = SpotCategory.find options[:spot_category_id] if options[:spot_category_id]

    if @selected_spot_category
      where_clause << "spot_category_id=#{@selected_spot_category.id}"
    end

    @spots_query_clause = where_clause.join(' and ')
    @filter_params = {}
    @filter_params[:website_id] = @selected_website.id if @selected_website
    @filter_params[:channel_id] = @selected_channel.id if @selected_channel
    @filter_params[:spot_category_id] = @selected_spot_category.id if @selected_spot_category
    @filter_params[:unit_type] = @selected_unit_type if @selected_unit_type
    Rails.logger.debug @filter_params
  end
end
