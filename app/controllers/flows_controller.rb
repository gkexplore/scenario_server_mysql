class FlowsController < ApplicationController
	def index

	end
	def create
		 @feature = Feature.find(params[:feature_id])
    	 @flow = @feature.flows.create(flow_params)
    	 redirect_to feature_path(@feature)
	end
	def new

	end
	def edit

	end
	def show
		@feature = Feature.find(params[:feature_id])
		@flow = @feature.flows.find(params[:id])

	end
	def update
		
	end
	def destroy
		@feature = Feature.find(params[:feature_id])
    	@flow = @feature.flows.find(params[:id])
   		@flow.destroy
   		render "features/show"
	end
	private
    def flow_params
      params.require(:flow).permit(:flow_name)
    end
end
