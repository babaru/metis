# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  # Specify a custom renderer if needed.
  # The default renderer is SimpleNavigation::Renderer::List which renders HTML lists.
  # The renderer can also be specified as option in the render_navigation call.
  # navigation.renderer = Your::Custom::Renderer

  # Specify the class that will be applied to active navigation items. Defaults to 'selected'
  navigation.selected_class = 'active'

  # Specify the class that will be applied to the current leaf of
  # active navigation items. Defaults to 'simple-navigation-active-leaf'
  navigation.active_leaf_class = 'nil'

  # Item keys are normally added to list items as id.
  # This setting turns that off
  navigation.autogenerate_item_ids = false

  # You can override the default logic that is used to autogenerate the item ids.
  # To do this, define a Proc which takes the key of the current item as argument.
  # The example below would add a prefix to each key.
  # navigation.id_generator = Proc.new {|key| "my-prefix-#{key}"}

  # If you need to add custom html around item names, you can define a proc that will be called with the name you pass in to the navigation.
  # The example below shows how to wrap items spans.
  # navigation.name_generator = Proc.new {|name| "<span>#{name}</span>"}

  # The auto highlight feature is turned on by default.
  # This turns it off globally (for the whole plugin)
  # navigation.auto_highlight = false

  # Define the primary navigation
  navigation.items do |primary|
    primary.item :page_dashboard, t('navigation.dashboard'), dashboard_path, link: {icon: 'icon-dashboard'}, :highlights_on => /dashboard/
    primary.item :page_clients, t('navigation.clients'), clients_path, link: {icon: 'icon-user'}, highlights_on: /clients/
    primary.item :page_websites, t('navigation.websites'), websites_path, link: {icon: 'icon-globe'}, highlights_on: /websites/ do |websites|
      websites.item :page_websites, t('navigation.websites'), websites_path, link: {icon: 'icon-globe'}, highlights_on: ::Regexp.new("websites$")
      Website.all.each do |item|
        websites.item "page_website_#{item.id}".to_sym, item.name, website_channels_path(item.id), highlights_on: ::Regexp.new("websites/#{item.id}")
      end
    end
    primary.item :page_spots, t('navigation.spots'), Website.count > 0 ? spots_path(website_id: Website.first) : nil, link: {icon: 'icon-book'}, highlights_on: /spots/ do |spots|
      Website.all.each do |website|
        spots.item "page_website_#{website.id}_spots".to_sym, website.name, spots_path(website_id: website), highlights_on: ::Regexp.new("website_id=#{website.id}")
      end
    end
  end

end
