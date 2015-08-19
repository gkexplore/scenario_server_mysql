class RoutesController < ApplicationController

	skip_before_action :verify_authenticity_token

	def index

	end

	def create
		begin
			@feature = Feature.find(params[:feature_id])
	    	@flow = @feature.flows.find(params[:flow_id])
	    	@scenario = @flow.scenarios.find(params[:scenario_id])
	    	params = route_params
	    	@route = Route.save_route(scenario, params)
	    	render "scenarios/show"
	    rescue=>e	
			alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while creating the route #{e.class.name}: #{e.message}", "", AadhiConstants::ALERT_BUTTON) 
		end
	end

	def new

	end

	def edit
		begin
			@feature = Feature.find(params[:feature_id])
			@flow = @feature.flows.find(params[:flow_id])
			@scenario = @flow.scenarios.find(params[:scenario_id])
			@route = @scenario.routes.find(params[:id])
		rescue=>e
			alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while editing the route #{e.class.name}: #{e.message}", "", AadhiConstants::ALERT_BUTTON) 
		end
	end

	def show
		begin
			@feature = Feature.find(params[:feature_id])
			@flow = @feature.flows.find(params[:flow_id])
			@scenario = @flow.scenarios.find(params[:scenario_id])
			@route = @scenario.routes.find(params[:id])
		rescue=>e
			alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while retrieving the route #{e.class.name}: #{e.message}", "", AadhiConstants::ALERT_BUTTON) 
		end
	end

	def update
		begin
			@feature = Feature.find(params[:feature_id])
			@flow = @feature.flows.find(params[:flow_id])
			@scenario = @flow.scenarios.find(params[:scenario_id])
			@route = @scenario.routes.find(params[:id])
			params = route_params
			  if Route.update_route(@route, params)
			    render "scenarios/show"
			  else
			    render 'routes/edit'
			  end
		rescue=>e
			alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while updating the route #{e.class.name}: #{e.message}", "", AadhiConstants::ALERT_BUTTON) 
		end
	end

	def destroy
		begin
			@feature = Feature.find(params[:feature_id])
			@flow = @feature.flows.find(params[:flow_id])
			@scenario = @flow.scenarios.find(params[:scenario_id])
			@route = @scenario.routes.find(params[:id])
			@route.destroy
			render "scenarios/show"
		rescue=>e
			alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while deleting the route #{e.class.name}: #{e.message}", "", AadhiConstants::ALERT_BUTTON) 
		end
	end
	
	private
	 def route_params
		params.require(:route).permit(:route_type,:path,:query,:request_body,:fixture,:status,:host)
	 end
	
end
