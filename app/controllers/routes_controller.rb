class RoutesController < ApplicationController
	skip_before_action :verify_authenticity_token
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
		@feature = Feature.find(params[:feature_id])
		@flow = @feature.flows.find(params[:flow_id])
		@scenario = @flow.scenarios.find(params[:scenario_id])
		@route = @scenario.routes.find(params[:id])
	end
	def show
		@feature = Feature.find(params[:feature_id])
		@flow = @feature.flows.find(params[:flow_id])
		@scenario = @flow.scenarios.find(params[:scenario_id])
		@route = @scenario.routes.find(params[:id])
	end
	def update
		@feature = Feature.find(params[:feature_id])
		@flow = @feature.flows.find(params[:flow_id])
		@scenario = @flow.scenarios.find(params[:scenario_id])
		@route = @scenario.routes.find(params[:id])
		  if @route.update(route_params)
		    render "scenarios/show"
		  else
		    render 'routes/edit'
		  end
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
