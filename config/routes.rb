Rails.application.routes.draw do
 
  get '/'=>'scenarios#index'
  put 'scenario/:scenario_name' =>'service#set_scenario'
  resources :service
  resources :scenarios
  get '*path'=>'service#respond_to_CMA_client'
  post '*path'=>'service#respond_to_CMA_client'

end
