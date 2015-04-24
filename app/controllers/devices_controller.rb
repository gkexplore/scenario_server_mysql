require 'socket' 
require 'cgi'
require 'json'
require 'faraday'

class DevicesController < ApplicationController

use Rack::MethodOverride
skip_before_filter :verify_authenticity_token
include DevicesHelper

	def respond_to_app_client

		config =  Config.all

		case config[0].server_mode

			when SERVER_MODE::REFRESH	
				#add refresh implementation here	
			when SERVER_MODE::RECORD
				method =  request.method
				make_request_to_actual_api(method)   
			else
				make_request_to_local_api_server
		end
		
	end

	def set_scenario  
		begin
		   @scenario = Scenario.find_by(:scenario_name=>params[:scenario_name])
		   if @scenario.blank?
		   		logger.debug "Invalid scenario: #{params[:scenario_name]}"
			    render :json => { :status => '404', :message => 'Not Found'}, :status => 404
			else
				@device = Device.find_or_initialize_by(:device_ip=>params[:device_ip])
		  		@device.update(scenario: @scenario)
			  	render :json => { :status => 'Ok', :message => 'Received'}, :status => 200 
		    end
		    rescue =>e
				logger.error "An error has been occurred in Set_Scenario #{e.class.name} : #{e.message}"
				render :json => { :status => '404', :message => 'Not Found'}, :status => 404
		end	
	end

end

