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
    primary.item(
      :page_dashboard,
      t('dashboard'),
      dashboard_path,
      {
        highlights_on: /dashboard/
      }
    )

    if current_user.is_sys_admin?
      primary.item(
        :page_spaces,
        Space.model_name.human,
        spaces_path,
        {
          highlights_on: /spaces/
        }
      )

    end

    primary.item(
      :page_clients,
      Client.model_name.human,
      nil,
      {
        highlights_on: /clients/
      }
    ) do |client_menu|

      # Client List
      # ------------------------------------------------------------------------

      client_menu.item(
        :page_client_list,
        t('model.list', model: Client.model_name.human),
        clients_path,
        {
          link:
          {
            icon: 'list'
          }
        }
      )

      # Client Sub Menu
      # ------------------------------------------------------------------------

      current_user.viewable_clients(current_space).each do |client|

        client_menu.item(
          "page_client_#{client.id}".to_sym,
          client.name,
          nil
        ) do |client_sub_menu|

          # 项目列表
          #---------------------------------------------------------------------

          client_sub_menu.item(
            "page_client_#{client.id}_item_projects".to_sym,
            t('model.list', model: Project.model_name.human),
            client_projects_path(client),
            {
              link:
              {
                icon: 'folder-close'
              }
            }
          )

          # 客户人员
          #---------------------------------------------------------------------

          client_sub_menu.item(
            "page_client_#{client.id}_item_assigns".to_sym,
            t('model.manager', model: ClientAssignment.model_name.human),
            assign_client_user_path(client),
            {
              link:
              {
                icon: 'male'
              }
            }
          )

          # 客户媒体政策
          #---------------------------------------------------------------------

          client_sub_menu.item(
            "page_client_#{client.id}_item_medium_policies".to_sym,
            t('model.manager', model: MediumPolicy.model_name.human),
            manage_client_medium_policies_path(client),
            {
              link:
              {
                icon: 'file-text'
              }
            }
          )

          if can? :manage, Client
            client_sub_menu.item(
              :page_client_items_divider_1, nil, nil, link: {divider: true})

            client_sub_menu.item(
              :page_edit_client,
              t('model.edit', model: Client.model_name.human),
              edit_client_path(client),
              link:
              {
                icon: 'pencil'
              }
            )

          end

        end
      end

      if can? :manage, Client

        client_menu.item(
          :page_clients_divider_1, nil, nil, link: {divider: true})

        client_menu.item(
          :page_create_client,
          t('model.create', model: Client.model_name.human),
          new_client_path,
          link:
          {
            icon: 'plus-sign'
          }
        )
      end
    end

    primary.item(
      :page_media,
      Medium.model_name.human,
      nil,
      highlights_on: /media/
    ) do |medium_menu|

      medium_menu.item(
        :page_medium_list,
        t('model.list', model: Medium.model_name.human),
        media_path,
        link:
        {
          icon: 'list'
        }
      )

      medium_menu.item(
        :page_spot_list,
        '刊例库',
        spots_path,
        link:
        {
          icon: 'search'
        }
      )

      if can? :manage, Medium
        medium_menu.item(
          :page_medium_menu_divider_1,
          nil,
          link:
          {
            divider: 'true'
          }
        )

        medium_menu.item(
          :page_new_medium,
          t('model.create', model: Medium.model_name.human),
          new_medium_path,
          link:
          {
            icon: 'plus-sign'
          }
        )

        medium_menu.item(
          :page_new_spot,
          t('model.create', model: Spot.model_name.human),
          new_spot_path,
          link:
          {
            icon: 'plus-sign'
          }
        )
      end

    end

    primary.item(
      :page_reports,
      '报表',
      nil
    )

    if current_user.is_sys_admin? || current_user.is_space_admin?(@space)
      primary.item(
        :page_users,
        User.model_name.human,
        nil,
        highlights_on: /users/
      ) do |user_menu|

        user_menu.item(
          :page_user_list,
          t('model.list', model: User.model_name.human),
          users_path,
          link:
          {
            icon: 'list'
          }
        )

        user_menu.item(
          :page_create_user,
          t('model.create', model: User.model_name.human),
          new_user_path,
          link:
          {
            icon: 'plus-sign'
          }
        )

        if can? :manage, Role

          user_menu.item(
            :page_user_menu_divider_1,
            nil,
            link:
            {
              divider: 'true'
            }
          )

          user_menu.item(
            :page_role_list,
            t('model.list', model: Role.model_name.human),
            roles_path,
            link:
            {
              icon: 'list'
            }
          )
        end

      end
    end
  end

end
