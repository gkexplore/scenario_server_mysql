Rails.application.routes.draw do

  get 'stub/index'

  get '/'=>'features#index'
  put 'scenario/:scenario_name/:device_ip' =>'devices#set_scenario',:constraints => { :device_ip => /[0-z\.]+/ }
  post 'features/export'=>'features#export'
  get 'features/import_json'=>'features#import_json_index'
  post 'features/import_json'=>'features#import_json'
  get 'stubs/poll_log'=>'stubs#poll_log'
  delete 'stubs/clear_logs'=>'stubs#clear_logs'
  get 'stubs/create_scenario'=>'stubs#create_scenario'
  post 'stubs/save_scenario'=>'stubs#save_scenario'
  resources :devices
  resources :stubs
  resources :config
    resources :features do
      resources :flows do
        resources :scenarios do
         resources :routes 
       end
    end
  end

  get '*path'=>'devices#respond_to_app_client'
  post '*path'=>'devices#respond_to_app_client'
  delete '*path'=>'devices#respond_to_app_client'
  put '*path'=>'devices#respond_to_app_client'
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
