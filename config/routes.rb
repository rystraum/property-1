Site::Application.routes.draw do
  devise_for :users
  
  # Current user or agent resources
  #
  
  resources :listings
  resources :users
  resources :searches
  
  # resource :agency, controller: 'agency' do
  #   resources :agents, controller: 'agency/agents'
  #   resources :listings, controller: 'agency/listings'
  # end
  
  # Public resources
  #
  
  resources :agencies do
    resources :agents, controller: 'agencies/agents'
    resources :listings, controller: 'agencies/listings'
  end

  # resources :agencies, only: [:index, :show] do
  #   resources :agents, controller: 'agencies/agents', only: [:index, :show]
  #   resources :listings, controller: 'agencies/listings', only: [:index, :show]
  # end

  root to: "listings#index"

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

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

end
