class DevicesController < ApplicationController
#To eliminate authentication token error
skip_before_filter :verify_authenticity_token

def respond_to_CMA_client
	begin
		remote_ip = "10.12.172.200"	
		received_path = params[:path]
		@device = Device.find_by(:device_ip=>remote_ip)
		@route = @device.scenario.routes.find_by(:path=>received_path,:route_type=>request.method)
		if @route.blank?
			render :json => { :status => '404', :message => 'Not Found'}, :status => 404
		else
			render json: @route.fixture, :status => @route.status
		end
	rescue =>e
		logger.error "An error has been occurred #{e.class.name} : #{e.message}"
		render :json => { :status => '404', :message => 'Not Found'}, :status => 404
	end	
end

def set_scenario  
	   @scenario = Scenario.find_by(:scenario_name=>params[:scenario_name])
	   if @scenario.blank?
	   		logger.debug "Invalid scenario: #{params[:scenario_name]}"
		    render :json => { :status => '404', :message => 'Not Found'}, :status => 404
		else
			@device = Device.find_or_initialize_by(:device_ip=>params[:device_ip])
	  		@device.update(scenario: @scenario)
		  	render :json => { :status => 'Ok', :message => 'Received'}, :status => 200 
	    end
	end
end

