class FeaturesController < ApplicationController

	#http_basic_authenticate_with name: "dhh", password: "secret", only: :index
	 skip_before_filter :verify_authenticity_token
	 include FeaturesHelper
	def index
		begin
			@features = Feature.all
			@flows = Flow.all
		rescue=>e
			alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while retrieving all the features #{e.class.name}: #{e.message}", "/features", AadhiConstants::ALERT_BUTTON)
		end
	end

	def create
		begin
			@feature = Feature.new(feature_params)
	  		if @feature.save
	  			redirect_to @feature
	  		else
	  			render 'new'
	  		end
  		rescue=>e
			alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while retrieving the feature #{e.class.name}: #{e.message}", "/features", AadhiConstants::ALERT_BUTTON)
  		end
	end
	
	def new
		begin
			@feature = Feature.new
		rescue=>e
			alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while creating new instance for a feature #{e.class.name}: #{e.message}", "/features", AadhiConstants::ALERT_BUTTON)
		end
	end
	
	def edit
		begin
			@feature = Feature.find(params[:id])
		rescue=>e
			alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while editing the feature #{e.class.name}: #{e.message}", "/features", AadhiConstants::ALERT_BUTTON)
		end
	end
	
	def show
		@feature = Feature.find(params[:id])
	end
	
	def update
		begin
			@feature = Feature.find(params[:id])
			  if @feature.update(feature_params)
			    redirect_to @feature
			  else
			    render 'edit'
			  end
		rescue=>e
			alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while updating the feature #{e.class.name}: #{e.message}", "/features", AadhiConstants::ALERT_BUTTON)
		end
	end
	
	def destroy
		begin
			@feature = Feature.find(params[:id])
			@feature.destroy
			alert(AadhiConstants::ALERT_CONFIRMATION, "The selected feature has been deleted successfully!!!", "/features", AadhiConstants::ALERT_BUTTON)
  		rescue=>e
			alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while deleting the feature #{e.class.name}: #{e.message}", "/features", AadhiConstants::ALERT_BUTTON)
		end
	end
	
	def export
		begin
			@features = Feature.where(:id=>params[:feature_ids]).includes({:flows =>{:scenarios => :routes}}).joins({:flows =>{:scenarios => :routes}})
			file_name = Time.now.to_s<<".xml"
			response_xml = @features.to_xml(:include => {:flows => {:include => {:scenarios =>{:include =>:routes}}}})
			send_data response_xml, :type=>'xml', :disposition => 'attachment', :filename => 'Stubs_'<<file_name
		rescue=>e
			alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while exporting the report!!! #{e.class.name}: #{e.message}", "/features", AadhiConstants::ALERT_BUTTON)
		end
	end

	def export_all
		begin
			@features = Feature.all.includes({:flows =>{:scenarios => :routes}}).joins({:flows =>{:scenarios => :routes}})
			file_name = Time.now.to_s<<".xml"
			response_xml = @features.to_xml(:include => {:flows => {:include => {:scenarios =>{:include =>:routes}}}})
			send_data response_xml, :type=>'xml', :disposition => 'attachment', :filename => 'Stubs_'<<file_name
		rescue=>e
			alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while exporting the report!!! #{e.class.name}: #{e.message}", "/features", AadhiConstants::ALERT_BUTTON)
		end
	end

	def import_xml_index

	end

	def import_xml
		begin
			file = params[:upload]
			if file['datafile'].content_type=="text/xml"
				store_json(file)
				File.delete("public/#{file['datafile'].original_filename}")
        		alert(AadhiConstants::ALERT_CONFIRMATION, "Your stubs have been uploaded successfully!!!", "/features", AadhiConstants::ALERT_BUTTON)
			else
				alert(AadhiConstants::ALERT_ERROR, "Please upload a valid xml file!!!", "/features", AadhiConstants::ALERT_BUTTON)
			end
		rescue=>e
				alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while importing the stubs!!! #{e.class.name}: #{e.message}", "/features", AadhiConstants::ALERT_BUTTON)
		end
	end

	private
	 def feature_params
		params.require(:feature).permit(:feature_name)
	 end
end
