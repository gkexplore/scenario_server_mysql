class FlowsController < ApplicationController
	skip_before_action :verify_authenticity_token
	def index

	end
	def create
	    begin
			 @feature = Feature.find(params[:feature_id])
	    	 @flow = @feature.flows.create(flow_params)
	    	 redirect_to feature_path(@feature)
	    rescue=>e
			render :text => "An error has been occurred while creating the flow #{e.class.name}: #{e.message}"
		end
	end
	def new

	end
	def edit
		begin
			@feature = Feature.find(params[:feature_id])
			@flow = @feature.flows.find(params[:id])
		 rescue=>e
			render :text => "An error has been occurred while editing the flow #{e.class.name}: #{e.message}"
		end
	end
	def show
		begin
			@feature = Feature.find(params[:feature_id])
			@flow = @feature.flows.find(params[:id])
		rescue=>e
			render :text => "An error has been occurred while retrieving the flow #{e.class.name}: #{e.message}"
		end

	end
	def update
	    begin
			@feature = Feature.find(params[:feature_id])
			@flow = @feature.flows.find(params[:id])
			  if @flow.update(flow_params)
			    render "features/show"
			  else
			    render 'flows/edit'
			  end
		rescue=>e
			render :text => "An error has been occurred while updating the flow #{e.class.name}: #{e.message}"
		end
	end
	def destroy
		begin
			@feature = Feature.find(params[:feature_id])
	    	@flow = @feature.flows.find(params[:id])
	   		@flow.destroy
	   		render "features/show"
	   	rescue=>e
			render :text => "An error has been occurred while destroy the flow #{e.class.name}: #{e.message}"
		end
	end
	private
    def flow_params
      params.require(:flow).permit(:flow_name)
    end
end
