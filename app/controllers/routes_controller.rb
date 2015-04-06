class RoutesController < ApplicationController
	def index

	end
	def create

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

	end
end
