class ScenariosController < ApplicationController
	skip_before_action :verify_authenticity_token
	def index

	end
	def create
		begin
			@feature = Feature.find(params[:feature_id])
	    	@flow = @feature.flows.find(params[:flow_id])
	    	@scenario = @flow.scenarios.create(scenario_params)
	    	render "flows/show"
	    rescue=>e	
			alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while creating the scenario #{e.class.name}: #{e.message}", "", AadhiConstants::ALERT_BUTTON) 
		end
	end
	def new

	end
	def edit
		begin
			@feature = Feature.find(params[:feature_id])
			@flow = @feature.flows.find(params[:flow_id])
			@scenario = @flow.scenarios.find(params[:id])
		rescue=>e	
			alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while editing the scenario #{e.class.name}: #{e.message}", "", AadhiConstants::ALERT_BUTTON) 
		end
	end
	def show
		begin
			@feature = Feature.find(params[:feature_id])
			@flow = @feature.flows.find(params[:flow_id])
			@scenario = @flow.scenarios.find(params[:id])
		rescue=>e	
			alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while retrieving the scenario #{e.class.name}: #{e.message}", "", AadhiConstants::ALERT_BUTTON)  
		end
	end
	def update
		begin
			@feature = Feature.find(params[:feature_id])
			@flow = @feature.flows.find(params[:flow_id])
			@scenario = @flow.scenarios.find(params[:id])
			  if @scenario.update(scenario_params)
			    render "flows/show"
			  else
			    render 'scenarios/edit'
			  end
		rescue=>e
			alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while updating the scenario #{e.class.name}: #{e.message}", "", AadhiConstants::ALERT_BUTTON)  
		end
	end
	def destroy
		begin
			@feature = Feature.find(params[:feature_id])
			@flow = @feature.flows.find(params[:flow_id])
			@scenario = @flow.scenarios.find(params[:id])
			@scenario.destroy
			render "flows/show"
		rescue=>e
			alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while deleting the scenario #{e.class.name}: #{e.message}", "", AadhiConstants::ALERT_BUTTON)  
		end
	end

	def debug
		begin
			remote_ip=request.remote_ip
			if remote_ip=="::1"
				@request_ip="127.0.0.1"
			else
				@request_ip=remote_ip
			end	
			@scenarios=Scenario.all
			@devices = Device.all
		rescue =>e
				alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while retrieving the device and scenario details", "/scenarios/debug", AadhiConstants::ALERT_BUTTON)  
		end
	end

	def set_current_scenario
		begin
		   @scenario = Scenario.find_by(:scenario_name=>params[:scenario_name])
		   if @scenario.blank?
			    alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while setting #{params[:scenario_name]} scenario. Please set a valid scenario", "/scenarios/debug", AadhiConstants::ALERT_BUTTON)  
			else
				@device = Device.find_or_initialize_by(:device_ip=>params[:device_ip])
		  		@device.update(scenario: @scenario)
			    alert(AadhiConstants::ALERT_CONFIRMATION, "The selected scenario has been set successfully!!!", "/scenarios/debug", AadhiConstants::ALERT_BUTTON)  
		    end
		rescue =>e
				alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while setting the scenario", "/scenarios/debug", AadhiConstants::ALERT_BUTTON)  
		end	
	end
	private
	 def scenario_params
		params.require(:scenario).permit(:scenario_name)
	 end
end
