Rails.application.routes.draw do

  get 'stub/index'
  get '/'=>'features#index'
  put 'scenario/:scenario_name/:device_ip' =>'devices#set_scenario',:constraints => { :device_ip => /[0-z\.]+/ }
  post 'features/export'=>'features#export'
  get 'features/import_json'=>'features#import_json_index'
  post 'features/import_json'=>'features#import_json'
  get 'stubs/poll_log'=>'stubs#poll_log'
  delete 'stubs/clear_logs'=>'stubs#clear_logs'
  post 'stubs/save_scenario'=>'stubs#save_scenario'
  get 'scenarios/debug'=>'scenarios#debug'
  post 'scenarios/set_current_scenario'=>'scenarios#set_current_scenario'
  get 'stubs/server_log'=>'stubs#server_log'
  delete 'stubs/clear_server_log'=>'stubs#clear_server_log'
  resources :devices
  resources :stubs
  resources :aadhiconfig
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
  
end
