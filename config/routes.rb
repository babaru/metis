Metis::Application.routes.draw do
  devise_for :users

  match 'spots/upload' => 'spots#upload', as: :upload_spots
  match 'websites/:id/data_type/:data_type/search' => 'websites#search', as: :website_data_search
  post 'projects/:id' => 'projects#show'
  get 'projects/:id/cart' => 'projects#view_cart', as: :view_project_cart

  get 'websites/:website_id/channel_groups' => 'channel_groups#index'

  resources :websites, :channels, :spots, :channel_groups, :spot_categories

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
  # match ':controller(/:action(/:id))(.:format)'
end
