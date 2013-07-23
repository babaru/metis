module Tida
  module Renderers
    class SubNavigationBarRenderer < ::SimpleNavigation::Renderer::Base
      def render(item_container)
        # header_content = content_tag :div, content_tag(:h3, item_container.selected_item ? item_container.selected_item.name : item_container.items.first.name), class: 'header'
        list_content = []
        if item_container.selected_item && include_sub_navigation?(item_container.selected_item)
          list_content = item_container.selected_item.sub_navigation.items.inject([]) do |list, item|
            Rails.logger.debug include_sub_navigation?(item)
            content = []
            content << tag_for_level_1(item)
            content << tag_for_level_2(item) if include_sub_navigation?(item)
            list << content_tag(:li, content_tag(:div, content.join, {class: 'accordion-group'}))
          end
        end
        menu_content = content_tag(:ul, list_content.join, {class: 'accordion'})
        div_content = []
        # div_content << header_content
        # div_content << menu_content
        content_tag(:div, menu_content, {id: 'sub-navigation-bar'})
      end

      protected

      def tag_for_level_1(item)
        item_content = nil
        options = options_for(item)
        icon = options.delete(:icon)
        if suppress_link?(item)
          content = []
          content << content_tag(:i, nil, class: icon) if icon
          content << content_tag(:span, item.name)
          content << content_tag(:b, nil, class: 'caret')
          if options[:class] && options[:class].include?('active')
            options[:class] = [options[:class], 'accordion-toggle in'].flatten.compact.join(' ')
          else
            options[:class] = [options[:class], 'accordion-toggle collapsed'].flatten.compact.join(' ')
          end
          options = options.merge('data-toggle' => "collapse", 'data-parent' => "#page-menu")
          item_content = link_to(content.join(' '), "#collapse_#{item.key}", options)
        else
          options[:class] = [options[:class], 'accordion-toggle'].flatten.compact.join(' ')
          content = []
          content << content_tag(:i, nil, class: icon) if icon
          content << content_tag(:span, item.name)
          item_content = link_to(content.join(' '), item.url, options)
        end
        li_content = content_tag :div, item_content, class: 'accordion-heading'
      end

      def tag_for_level_2(item)
        Rails.logger.debug "sub_navigation"
        sub_list_content = item.sub_navigation.items.inject([]) do |list, sub_item|
          options = link_options_for(sub_item)
          icon = options.delete(:icon)
          content = []
          content << content_tag(:i, nil, class: icon) if icon
          content << content_tag(:span, sub_item.name)
          li_content = link_to(content.join(' '), sub_item.url, options)
          list << content_tag(:li, li_content)
        end.join
        sub_list = content_tag(:ul, sub_list_content)
        inner_container = content_tag(:div, sub_list, class: 'accordion-inner')
        if item.selected?
          content_tag(:div, inner_container, {:class => 'accordion-body in collapse active', 'id' => "collapse_#{item.key}"})
        else
          content_tag(:div, inner_container, {:class => 'accordion-body collapse', 'id' => "collapse_#{item.key}"})
        end
      end
    end
  end
end
