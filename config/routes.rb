Metis::Application.routes.draw do
  devise_for :users

  scope "/admin" do
    resources :users, :roles
  end

  match 'spots/upload' => 'spots#upload', as: :upload_spots

  get 'clients/:id/assigned_users' => 'clients#assigned_users', as: :client_assigned_users
  get 'clients/:id/assign' => 'clients#assign', as: :manage_client_assignment
  match 'clients/:id/discounts' => 'clients#discounts', as: :manage_client_discounts

  match 'websites/:id/data_type/:data_type/search' => 'websites#search', as: :website_data_search
  match 'projects/:id/assign' => 'projects#assign', as: :assign_project

  # get 'websites/:website_id/channel_groups' => 'channel_groups#index'
  # get 'websites/:website_id/channels' => 'channels#index'

  get 'master_plans/:id/choose_spots' => 'master_plans#choose_spots', as: :choose_spots
  get 'master_plans/:id/spot_plan' => 'master_plans#spot_plan', as: :spot_plan
  # get 'spot_plan'=> 'master_plan_items#index', as: :spot_plan
  match 'master_plans/:id/generate_spot_plan' => 'master_plans#generate_spot_plan', as: :generate_spot_plan
  # match 'spot_plan/generate' => 'spot_plan_items#generate', as: :generate_spot_plan
  match 'master_plans/:id/save_spot_plan' => 'master_plans#save_spot_plan', as: :save_spot_plan
  # match 'spot_plan/save' => 'master_plans#save_version', as: :save_spot_plan
  match 'spot_plan_items/:id/modify_placed_at' => 'spot_plan_items#modify_placed_at', as: :modify_placed_at

  post 'master_plan_items/:id/modify' => 'master_plan_items#modify', as: :modify_master_plan_item
  match 'clients/:id/upload_spot_plan_excel_file' => 'clients#upload_spot_plan_excel_file', as: :upload_spot_plan_excel_file

  get 'spots/apps' => 'spots#apps'

  resources :websites, :channels, :spots, :channel_groups, :spot_categories, :master_plans, :master_plan_items, :spot_plan_items

  resources :websites do
    resources :channels, :channel_groups, :spots
  end

  resources :channel_groups do
    resources :channels
  end

  resources :channels do
    resources :spots
  end

  resources :clients do
    resources :projects
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
