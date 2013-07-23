module Tida
  module Renderers
    class TopNavigationBarRenderer < ::SimpleNavigation::Renderer::Base
      def render(item_container)
        ul_content = item_container.items.inject([]) do |list, item|
          list << item_content(item)
        end.join
        div_content = content_tag :ul, ul_content
        content_tag(:div, div_content, {id: "top-navigation-bar"})
      end

      protected

      def item_content(item)
        content_tag :li, tag_for(item)
      end

      def tag_for(item)
        options = options_for(item)
        icon = options.delete(:icon)
        stack_icon = options.delete(:stack_icon)
        content = []
        if stack_icon
          stack_content = []
          stack_content << content_tag(:i, nil, class: "icon-stack-base #{stack_icon[:base]}")
          stack_content << content_tag(:i, nil, class: stack_icon[:icon])
          stack = content_tag(:span, stack_content.join(), class: 'icon-stack')
          content << stack
        else
          content << content_tag(:i, nil, class: "#{icon} icon-2x")
        end
        content << content_tag(:span, item.name)
        link_to content.join('<br>'), item.url, options
      end
    end
  end
end
