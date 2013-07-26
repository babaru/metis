module SpotsHelper
  def render_query_item(key_name, value, link_name, options)
    params = {}
    params[key_name] = value
    options.map {|k, v| params[k] = v if v && k.to_s != key_name.to_s}
    class_string = ""
    class_string = "label" if value == options[key_name]
    return link_to(link_name, spots_path(params), class: class_string)
  end

  def render_filter_item(link_name, options)
    params = {}
    options.map {|k, v| params[k] = v if v}
    return link_to("#{link_name} X", spots_path(params), class: 'label label-warning')
  end

  def render_spec(data)
    content = []
    if data
      data.each_with_index do |spec, index|
        content << '|' if index > 0
        content << content_tag(:span, spec[:dimension], class: 'label')
        content << content_tag(:span, spec[:size], class: 'label')
        if spec[:types]
          spec[:types].each do |type|
            if type.upcase == 'JPG'
              content << content_tag(:span, type, class: 'label label-warning')
            elsif type.upcase == 'SWF'
              content << content_tag(:span, type, class: 'label label-important')
            elsif type.upcase == 'GIF'
              content << content_tag(:span, type, class: 'label label-success')
            else
              content << content_tag(:span, type, class: 'label')
            end
          end
        end

        content << content_tag(:span, spec[:remark],class: 'label') if spec[:remark]
      end
    end
    content.join(' ').html_safe
  end
end
