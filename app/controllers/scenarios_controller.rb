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
			render :text => "An error has been occurred while creating the scenario #{e.class.name}: #{e.message}"
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
			render :text => "An error has been occurred while editing the scenario #{e.class.name}: #{e.message}"
		end
	end
	def show
		begin
			@feature = Feature.find(params[:feature_id])
			@flow = @feature.flows.find(params[:flow_id])
			@scenario = @flow.scenarios.find(params[:id])
		rescue=>e
			render :text => "An error has been occurred while retrieving the scenario #{e.class.name}: #{e.message}"
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
			render :text => "An error has been occurred while updating the scenario #{e.class.name}: #{e.message}"
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
			render :text => "An error has been occurred while deleting the scenario #{e.class.name}: #{e.message}"
		end
	end

	private
	 def scenario_params
		params.require(:scenario).permit(:scenario_name)
	 end
end
