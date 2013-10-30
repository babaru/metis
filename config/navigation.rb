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
    primary.item :page_dashboard, t('dashboard'), dashboard_path, link: {icon: 'dashboard'}, :highlights_on => /dashboard/
    primary.item :page_clients, Client.model_name.human, nil, link: {icon: 'briefcase'} do |clients|
      clients.item :page_client_list, t('model.list', model: Client.model_name.human), clients_path, link: {icon: 'list-ul'}, highlights_on: ::Regexp.new("clients$")
      current_user.viewable_clients.each do |client|
        clients.item "page_client_#{client.id}".to_sym, client.name, nil, link: {icon: 'circle-o'}, highlights_on: ::Regexp.new("clients/#{client.id}") do |client_items|
          client_items.item "page_client_#{client.id}_item_projects".to_sym,
            t('model.list', model: Project.model_name.human),
            client_projects_path(client),
            link: {icon: 'folder'},
            highlights_on: ::Regexp.new("clients/#{client.id}/projects")

          client_items.item "page_client_#{client.id}_item_assigns".to_sym,
            t('model.manager', model: ClientAssignment.model_name.human),
            manage_client_assignments_path(client),
            link: {icon: 'male'},
            highlights_on: ::Regexp.new("clients/#{client.id}/assigns")

          client_items.item "page_client_#{client.id}_item_medium_policies".to_sym,
            t('model.manager', model: MediumPolicy.model_name.human),
            manage_client_medium_policies_path(client),
            link: {icon: 'file-text'},
            highlights_on: ::Regexp.new("clients/#{client.id}/medium_policies")
        end
      end
    end
    primary.item :page_spots, Spot.model_name.human, nil, link: {icon: 'map-marker'} do |media|
      media.item :page_media, t('model.list', model: Medium.model_name.human), media_path, highlights_on: ::Regexp.new("media$")
      Medium.all.each do |item|
        media.item "page_medium_#{item.id}".to_sym, item.name, medium_spots_path(item.id), highlights_on: ::Regexp.new("media/#{item.id}")
      end
    end

    if can? :manage, User
      primary.item :page_users, User.model_name.human, nil, link: {icon: 'male'} do |users|
        users.item :page_user_list, t('model.list', model: User.model_name.human), users_path, highlights_on: ::Regexp.new("users$")
      end
    end
  end

end
