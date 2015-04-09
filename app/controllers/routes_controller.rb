class RoutesController < ApplicationController
	def index

	end
	def create
		@feature = Feature.find(params[:feature_id])
    	@flow = @feature.flows.find(params[:flow_id])
    	@scenario = @flow.scenarios.find(params[:scenario_id])
    	@route = @scenario.routes.create(route_params)
    	render "scenarios/show"
	end
	def new

	end
	def edit

	end
	def show
		@feature = Feature.find(params[:feature_id])
		@flow = @feature.flows.find(params[:flow_id])
		@scenario = @flow.scenarios.find(params[:scenario_id])
		@route = @scenario.routes.find(params[:id])
	end
	def update
		
	end
	def destroy
		@feature = Feature.find(params[:feature_id])
		@flow = @feature.flows.find(params[:flow_id])
		@scenario = @flow.scenarios.find(params[:scenario_id])
		@route = @scenario.routes.find(params[:id])
		@route.destroy
		render "scenarios/show"
	end
	private
	 def route_params
		params.require(:route).permit(:route_type,:path,:query,:request_body,:fixture,:status,:host)
	 end
end
