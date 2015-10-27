Rails.application.routes.draw do

  get 'notfound/notfound'
  get 'stub/index'
  get '/'=>'features#index'
  delete 'delete_report'=>'devices#delete_report'

  put 'scenario/:scenario_name/:device_ip/:isReportRequired' =>'devices#set_scenario',:constraints => { :device_ip => /[0-z\.]+/ }
  
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
  post 'scenarios/copy_route'=>'scenarios#copy_route'


  get 'stubs/poll_log'=>'stubs#poll_log'
  delete 'stubs/clear_logs'=>'stubs#clear_logs'
  post 'stubs/save_scenario'=>'stubs#save_scenario'
  get 'stubs/server_log'=>'stubs#server_log'
  get 'stubs/poll_server_log'=>'stubs#poll_server_log'
  delete 'stubs/clear_server_log'=>'stubs#clear_server_log'

  get 'report/index'=>'report#report'
  get 'report/export'=>'report#export'


  get 'notfound/notfound_list'=>'notfound#notfound_list'
  delete 'notfound/clear_notfound_list'=>'notfound#clear_notfound_list'
  

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


  get '*path'=>'devices#respond_to_app_client'
  post '*path'=>'devices#respond_to_app_client'
  delete '*path'=>'devices#respond_to_app_client'
  put '*path'=>'devices#respond_to_app_client'
  
end
