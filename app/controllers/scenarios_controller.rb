class ScenariosController < ApplicationController
	def index

	end
	def create
		@feature = Feature.find(params[:feature_id])
    	@flow = @feature.flows.find(params[:flow_id])
    	@scenario = @flow.scenarios.create(scenario_params)
    	render "flows/show"
	end
	def new

	end
	def edit
		@feature = Feature.find(params[:feature_id])
		@flow = @feature.flows.find(params[:flow_id])
		@scenario = @flow.scenarios.find(params[:id])
	end
	def show
		@feature = Feature.find(params[:feature_id])
		@flow = @feature.flows.find(params[:flow_id])
		@scenario = @flow.scenarios.find(params[:id])
	end
	def update
		
	end
	def destroy
		@feature = Feature.find(params[:feature_id])
		@flow = @feature.flows.find(params[:flow_id])
		@scenario = @flow.scenarios.find(params[:id])
		@scenario.destroy
		render "flows/show"
	end

	private
	 def scenario_params
		params.require(:scenario).permit(:scenario_name)
	 end
end
