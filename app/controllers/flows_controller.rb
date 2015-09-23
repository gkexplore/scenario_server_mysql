class FlowsController < ApplicationController

	skip_before_action :verify_authenticity_token

	def index

	end

	def create
	    begin
			 @feature = Feature.find(params[:feature_id])
	    	 @flow = @feature.flows.create(flow_params)
	    	 flash[:success] = "The flow has been created successfully!!!"
	    	 redirect_to feature_path(@feature)
	    rescue=>e
			 flash[:danger] = "An error has been occurred while creating the flow #{e.class.name}: #{e.message}"
			 redirect_to feature_path(@feature)
		end
	end

	def new

	end

	def edit
		begin
			@feature = Feature.find(params[:feature_id])
			@flow = @feature.flows.find(params[:id])
		 rescue=>e
			flash[:danger] = "An error has been occurred while editing the flow #{e.class.name}: #{e.message}"
			redirect_to feature_path(@feature)
		end
	end

	def show
		begin
			@feature = Feature.find(params[:feature_id])
			@flow = @feature.flows.find(params[:id])
			@device_ip = request.remote_ip
		rescue=>e
			flash[:danger] = "An error has been occurred while retrieving the flow #{e.class.name}: #{e.message}"
			redirect_to feature_path(@feature)
		end

	end

	def update
	    begin
			@feature = Feature.find(params[:feature_id])
			@flow = @feature.flows.find(params[:id])
			if @flow.update(flow_params)
			   flash.now[:success] = "The flow has been updated successfully !!!"
			   render 'features/show'
			end
		rescue=>e	
			flash.now[:danger] = "An error has been occurred while updating the flow #{e.class.name}: #{e.message}"
			render 'flows/edit'
		end
	end

	def destroy
		begin
			@feature = Feature.find(params[:feature_id])
	    	@flow = @feature.flows.find(params[:id])
	   		@flow.destroy
	   		flash.now[:success] = "The flow has been deleted successfully !!!"
	   		render 'features/show'
	   	rescue=>e
			flash[:danger] = "An error has been occurred while destroy the flow #{e.class.name}: #{e.message}"
			redirect_to feature_path(@feature)
		end
	end

	private
    def flow_params
      params.require(:flow).permit(:flow_name)
    end

end
