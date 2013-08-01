module SpotsHelper
  def render_selector_item(key_name, value, link_name, opt)
    options = {}
    options = params.merge options
    opt.map {|k, v| options[k] = v if v && k.to_s != key_name.to_s}
    options[key_name] = value
    class_string = ""
    class_string = "active" if value == opt[key_name]
    return content_tag(:li, link_to(link_name, options), class: class_string)
  end

  def render_selected_item(key_name, link_name, opt)
    options = {}
    options = params.merge options
    opt.map {|k, v| options[k] = v if v}
    options[key_name] = nil
    return content_tag(:li, link_to("#{link_name} X", options, class: 'label label-warning'))
  end
end
