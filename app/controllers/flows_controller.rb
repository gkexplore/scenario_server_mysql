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
			alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while creating the flow #{e.class.name}: #{e.message}", "", AadhiConstants::ALERT_BUTTON)
		end
	end
	def new

	end
	def edit
		begin
			@feature = Feature.find(params[:feature_id])
			@flow = @feature.flows.find(params[:id])
		 rescue=>e
			alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while editing the flow #{e.class.name}: #{e.message}", "", AadhiConstants::ALERT_BUTTON)
		end
	end
	def show
		begin
			@feature = Feature.find(params[:feature_id])
			@flow = @feature.flows.find(params[:id])
			@device_ip = request.remote_ip
		rescue=>e
			alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while retrieving the flow #{e.class.name}: #{e.message}", "", AadhiConstants::ALERT_BUTTON)
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
			alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while updating the flow #{e.class.name}: #{e.message}", "", AadhiConstants::ALERT_BUTTON)
		end
	end
	def destroy
		begin
			@feature = Feature.find(params[:feature_id])
	    	@flow = @feature.flows.find(params[:id])
	   		@flow.destroy
	   		render "features/show"
	   	rescue=>e
			alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while destroy the flow #{e.class.name}: #{e.message}", "", AadhiConstants::ALERT_BUTTON)
		end
	end
	private
    def flow_params
      params.require(:flow).permit(:flow_name)
    end
end
