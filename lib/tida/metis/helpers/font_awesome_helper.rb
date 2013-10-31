module Tida
  module Metis
    module Helpers
      module FontAwesomeHelper

        def fa_icon(name, options = {})
          text = options[:text]
          content = []
          content << content_tag(:i, nil, class: "icon-#{name}")
          content << text if text
          content.join(' ')
        end

        def fa_stack_icon(name, options = {})
          text = options[:text]
          base = options[:base]

          content = []
          content << content_tag(:span,
            [
              content_tag(:i, nil, class: "icon-#{base} icon-stack-base"),
              content_tag(:i, nil, class: "icon-#{name}")
            ].join,
            class: 'icon-stack'
            )
          content << text if text
          content.join(' ')
        end

      end
    end
  end
end
