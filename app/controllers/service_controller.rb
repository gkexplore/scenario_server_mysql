class ServiceController < ApplicationController

#To eliminate authentication token error
skip_before_filter :verify_authenticity_token

def respond_to_CMA_client

	begin

	current_scenario = Rails.application.config.scenario
		
	logger.debug "****************** Current scenario is: #{current_scenario}**********************"
		
	received_path = params[:path]

	@scenario = Scenario.find_by(:name=>current_scenario)
	
	@route = @scenario.routes.find_by(:path=>received_path)

	logger.debug "route fixture:"<<@route.fixture

	render json: @route.fixture, :status => @route.status
	
	rescue =>e
		logger.error "An error has been occurred #{e.class.name} : #{e.message}"
		render :json => { :status => '404', :message => 'Not Found'}, :status => 404
	end	

end

def set_scenario
	   
	   @scenario = Scenario.find_by(:name=>params[:scenario_name])

	   if @scenario.blank?
	   		logger.debug "Invalid scenario: #{params[:scenario_name]}"
		    render :json => { :status => '404', :message => 'Not Found'}, :status => 404
		else
			puts "********************not nil"
		  	Rails.application.config.scenario = @scenario.name
		  	respond_to do |format|	
			format.json { render :json => { :status => 'Ok', :message => 'Received'}, :status => 200 }
	  		end
	    end
	end
end
