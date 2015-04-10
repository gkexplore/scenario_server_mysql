class FlowsController < ApplicationController
	skip_before_action :verify_authenticity_token
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
		@feature = Feature.find(params[:feature_id])
		@flow = @feature.flows.find(params[:id])
	end
	def show
		@feature = Feature.find(params[:feature_id])
		@flow = @feature.flows.find(params[:id])

	end
	def update
		@feature = Feature.find(params[:id])
		@flow = @feature.flows.find(params[:id])
		  if @flow.update(flow_params)
		    render "features/show"
		  else
		    render 'flows/edit'
		  end
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
