Rails.application.routes.draw do
    root :to => 'application#index'

    get 'login' => 'account#login'

    get 'signup' => 'account#signup'

    post 'login' => 'account#login_user'

    post 'signup' => 'account#signup_user'

    get 'logout' => 'account#logout'

    get 'dashboard' => 'home#dashboard'

    post 'dashboard/upload' => 'home#upload' 

    get 'playlist' => 'home#view_playlist'

    get 'music' => 'home#get_music'

    post 'dashboard/create_playlist' => 'home#create_playlist'

    get 'get_songs' => 'home#get_songs'

    post 'add_to_playlist' => 'home#add_to_playlist'

    get 'my_playlists' => 'home#my_playlists'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
