Rails.application.routes.draw do

  get 'stub/index'
  get '/'=>'features#index'
  put 'scenario/:scenario_name/:device_ip' =>'devices#set_scenario',:constraints => { :device_ip => /[0-z\.]+/ }
  post 'features/export'=>'features#export'
  get 'features/import_xml'=>'features#import_xml_index'
  post 'features/import_xml'=>'features#import_xml'
  get 'features/export_all'=>'features#export_all'
  get 'stubs/poll_log'=>'stubs#poll_log'
  delete 'stubs/clear_logs'=>'stubs#clear_logs'
  post 'stubs/save_scenario'=>'stubs#save_scenario'
  get 'scenarios/debug'=>'scenarios#debug'
  get 'scenarios/device_list'=>'scenarios#device_list'
  delete 'scenarios/clear_device_list'=>'scenarios#clear_device_list'
  post 'scenarios/set_current_scenario'=>'scenarios#set_current_scenario'
  get 'stubs/server_log'=>'stubs#server_log'
  delete 'stubs/clear_server_log'=>'stubs#clear_server_log'
  put 'report/:device_ip/:testcase_name'=>'report#report'
  put 'report/testcase_status/:device_ip/:testcase_name/:status'=>'report#testcase_status'
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
