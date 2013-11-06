Metis::Application.routes.draw do
  devise_for :users

  scope "/admin" do
    resources :users, :roles
  end

  match 'spots/upload' => 'spots#upload', as: :upload_spots

  get 'clients/:id/assign_user' => 'clients#assign_user', as: :assign_client_user
  post 'clients/:id/save_user_assignments' => 'clients#save_user_assignments', as: :save_client_user_assignments
  get 'clients/:id/medium_policies' => 'clients#medium_policies', as: :manage_client_medium_policies
  post 'clients/:id/save_medium_policies' => 'clients#save_medium_policies', as: :save_client_medium_policies

  get 'projects/:id/assign_user' => 'projects#assign_user', as: :assign_project_user
  post 'projects/:id/save_user_assignments' => 'projects#save_user_assignments', as: :save_project_user_assignments
  post 'projects/:id/set_current_master_plan' => 'projects#set_current_master_plan', as: :set_current_master_plan

  # get 'media/:website_id/channel_groups' => 'channel_groups#index'
  # get 'media/:website_id/channels' => 'channels#index'

  get 'clients/:client_id/projects/:project_id/master_plans/:id/choose_spots' => 'master_plans#choose_spots', as: :choose_spots
  post 'master_plans/:id/add_to_cart' => 'master_plans#add_to_cart', as: :add_to_cart
  post 'master_plans/:id/modify_cart' => 'master_plans#modify_cart', as: :modify_cart
  post 'master_plans/:id/remove_from_cart' => 'master_plans#remove_from_cart', as: :remove_from_cart
  post 'master_plans/:id/go_combo' => 'master_plans#go_combo', as: :go_combo
  post 'master_plans/:id/remove_medium_from_cart' => 'master_plans#remove_medium_from_cart', as: :remove_medium_from_cart
  post 'master_plans/:id/clear_cart' => 'master_plans#clear_cart', as: :clear_cart
  post 'master_plans/:id/save_candidates' => 'master_plans#save_candidates_to_master_plan', as: :save_candidates_to_master_plan
  post 'master_plans/:id/clone' => 'master_plans#clone_master_plan', as: :clone_master_plan
  post 'master_plans/:id/remove_spot_plan_version' => 'master_plans#remove_spot_plan_version', as: :remove_spot_plan_version

  post 'medium_master_plans/:id/get_combo' => 'medium_master_plans#get_combo', as: :medium_master_plan_get_combo
  post 'medium_master_plans/:id/out_of_combo' => 'medium_master_plans#out_of_combo', as: :medium_master_plan_out_of_combo
  post 'medium_master_plans/:id/modify' => 'medium_master_plans#modify', as: :modify_medium_master_plan

  get 'clients/:client_id/projects/:project_id/master_plans/:id/spot_plan' => 'master_plans#spot_plan', as: :spot_plan

  post 'master_plans/:id/generate_spot_plan' => 'master_plans#generate_spot_plan', as: :generate_spot_plan
  post 'master_plans/:id/confirm' => 'master_plans#confirm_spot_plan', as: :confirm_spot_plan
  match 'spot_plan_items/:id/modify_placed_at' => 'spot_plan_items#modify_placed_at', as: :modify_placed_at

  post 'master_plan_items/:id/modify' => 'master_plan_items#modify', as: :modify_master_plan_item
  match 'clients/:id/upload_spot_plan_excel_file' => 'clients#upload_spot_plan_excel_file', as: :upload_spot_plan_excel_file

  get 'spaces/:id/assign_user' => 'spaces#assign_user', as: :assign_space_user
  post 'spaces/:id/save_user_assignments' => 'spaces#save_user_assignments', as: :save_space_user_assignments
  get 'spaces/:id/assign_client' => 'spaces#assign_client', as: :assign_space_client
  post 'spaces/:id/save_client_assignments' => 'spaces#save_client_assignments', as: :save_space_client_assignments
  get 'spaces/:id/switch' => 'spaces#switch', as: :switch_space

  get 'space_users/:id/assign_space_user_roles' => 'space_users#assign_space_user_roles', as: :assign_space_user_roles
  post 'space_users/:id/save_space_user_roles' => 'space_users#save_space_user_roles', as: :save_space_user_roles

  # post 'master_plans/:id/modify' => 'master_plans#modify', as: :modify_master_plan

  # get 'spots/apps' => 'spots#apps'

  resources :spaces, :media, :channels, :spots, :channel_groups, :spot_categories,
    :master_plans, :master_plan_items, :spot_plan_items, :medium_policies,
    :medium_master_plans

  resources :shopping_cart_items

  resources :media do
    resources :channels, :channel_groups, :spots, :spot_categories
  end

  resources :channel_groups do
    resources :channels
  end

  resources :channels do
    resources :spots
  end

  resources :clients do
    resources :projects do
      resources :master_plans
    end
  end

  resources :projects do
    resources :master_plans
  end

  resources :master_plans do
    resources :master_plan_items
  end

  resources :master_plan_items do
    resources :spot_plan_items
  end

  resources :upload_files

  resources :clients, :projects

  root to: 'dashboard#index', as: :dashboard

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  match ':controller(/:action(/:id))(.:format)'
end
