module SpotsHelper
  def render_unit_type_query_item(unit_type, selected_website = nil, selected_channel = nil, selected_unit_type = nil)
    params = {}
    params[:unit_type] = unit_type
    params[:channel_id] = selected_channel.id if selected_channel
    params[:website_id] = selected_website.id if selected_website

    class_string = ""
    if selected_unit_type == unit_type
      class_string = "label"
    end

    return link_to(t("activerecord.attributes.spot.unit_type.#{unit_type}"), spots_path(params), class: class_string)
  end

  def render_remove_unit_type_query_item(unit_type, selected_website = nil, selected_channel = nil)
    params = {}
    params[:channel_id] = selected_channel.id if selected_channel
    params[:website_id] = selected_website.id if selected_website

    key_string = "activerecord.attributes.spot.unit_type.#{unit_type}"

    return link_to("#{t(key_string)} X", spots_path(params), class: 'label label-warning')
  end

  def render_website_query_item(website, selected_website = nil, selected_channel = nil, selected_unit_type = nil)
    params = {}
    params[:unit_type] = selected_unit_type if selected_unit_type
    params[:channel_id] = selected_channel.id if selected_channel
    params[:website_id] = website.id

    class_string = ""
    if selected_website && selected_website.id == website.id
      class_string = "label"
    end

    return link_to(website.name, spots_path(params), class: class_string)
  end

  def render_remove_website_query_item(website, selected_channel = nil, selected_unit_type = nil)
    params = {}
    params[:channel_id] = selected_channel.id if selected_channel
    params[:unit_type] = selected_unit_type if selected_unit_type

    return link_to("#{website.name} X", spots_path(params), class: 'label label-warning')
  end
end
