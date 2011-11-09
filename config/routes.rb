WhereAmI::Application.routes.draw do
  get "bluevia/auth"

  get "pages/about_us"

  get "pages/contact"

  devise_for :users

  get "whitelist/create"

  get "whitelist/destroy"

  get "whitelist/edit"

  get "main/index"

  match 'whitelist/modify', :to => 'whitelist#modify'
  match 'whitelist/create', :to => 'whitelist#create'
  match 'whitelist/index', :to => 'whitelist#index'
  match 'whitelist/edit', :to => 'whitelist#edit'
  match 'whitelist', :to => 'whitelist#index'



  match 'hashblue/', :to => "hashblue#index"
  match '/callback', :to => "hashblue#callback"
  match 'users/contact', :to => "pages#contact"
  match 'users/index', :to => "main#index"
  match 'users/about_us', :to => "pages#about_us"

  match '/callbackblue', :to => "bluevia#callbackblue"
  match 'bluevia/calllocation', :to => "bluevia#calllocation"
  devise_for :users

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
   root :to => 'main#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
