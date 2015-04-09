class ScenariosController < ApplicationController
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
end
