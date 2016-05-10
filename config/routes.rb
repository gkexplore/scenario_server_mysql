Rails.application.routes.draw do

  get '/'=>'features#index'
  get 'status'=>'devices#status'
  delete 'clear_all_logs'=>'devices#clear_all_logs'
  put 'set_default_mode'=>'devices#set_default_mode'


  post 'features/export'=>'features#export'
  get 'features/import_xml'=>'features#import_xml_index'
  post 'features/import_xml'=>'features#import_xml'
  post 'features/upload_stubs'=>'features#upload_stubs'
  get 'features/export_all'=>'features#export_all'
  delete 'features/delete_all'=>'features#delete_all'


  get 'scenarios/debug'=>'scenarios#debug'
  get 'scenarios/device_list'=>'scenarios#device_list'
  delete 'scenarios/clear_device_list'=>'scenarios#clear_device_list'
  post 'scenarios/set_current_scenario'=>'scenarios#set_current_scenario'
  get 'scenarios/copy_or_find_route'=>'scenarios#copy_or_find_route'
  post 'scenarios/save_route'=>'scenarios#save_route'
  post 'scenarios/insert_or_update_routes'=>'scenarios#insert_or_update_routes'
  get 'scenarios/revert_marked_scenarios'=>'scenarios#revert_marked_scenarios'
  put 'scenario/:scenario_name/:device_ip/:isReportRequired' =>'devices#set_scenario',:constraints => { :device_ip => /[0-z\.]+/ }


  get 'stubs/poll_log'=>'stubs#poll_log'
  delete 'stubs/clear_logs'=>'stubs#clear_logs'
  post 'stubs/save_scenario'=>'stubs#save_scenario'
  get 'stubs/server_log'=>'stubs#server_log'
  get 'stubs/poll_server_log'=>'stubs#poll_server_log'
  delete 'stubs/clear_server_log'=>'stubs#clear_server_log'

  get 'report/index'=>'report#report'
  get 'report/export'=>'report#export'
  get 'report/import_report'=>'report#import_report'
  post 'report/upload_report'=>'report#upload_report'
  get 'report/scenarios_by_device'=>'report#scenarios_by_device'
  get 'report/routes_by_scenario'=>'report#routes_by_scenario'
  delete 'report/delete_report'=>'report#delete_report'


  get 'notfound/notfound_list'=>'notfound#notfound_list'
  delete 'notfound/clear_notfound_list'=>'notfound#clear_notfound_list'


  get 'search/search_scenario_index'=>'search#search_scenario_index'
  get 'search/search_route_index'=>'search#search_route_index'
  get 'search/search_scenario'=>'search#search_scenario'
  get 'search/search_route'=>'search#search_route'
  

  resources :notfound
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

  delete 'delete_report'=>'devices#delete_report'
  get '*path'=>'devices#respond_to_app_client'
  post '*path'=>'devices#respond_to_app_client'
  delete '*path'=>'devices#respond_to_app_client'
  put '*path'=>'devices#respond_to_app_client'
  patch '*path'=>'devices#respond_to_app_client'
  
end
