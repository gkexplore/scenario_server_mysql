class FeaturesController < ApplicationController

	#http_basic_authenticate_with name: "dhh", password: "secret", only: :index
	 skip_before_filter :verify_authenticity_token
	 include FeaturesHelper
	def index
		begin
			@features = Feature.all
		rescue=>e
			render :text =>"An error has been occurred while retrieving all the features #{e.class.name}: #{e.message}"
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
  			render :text =>"An error has been occurred while retrieving the feature #{e.class.name}: #{e.message}" 
  		end
	end
	
	def new
		begin
			@feature = Feature.new
		rescue=>e
			render :text =>"An error has been occurred while creating new instance for a feature #{e.class.name}: #{e.message}"
		end
	end
	
	def edit
		begin
			@feature = Feature.find(params[:id])
		rescue=>e
			render :text => "An error has been occurred while editing the feature #{e.class.name}: #{e.message}"
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
			render :text => "An error has been occurred while updating the feature #{e.class.name}: #{e.message}"
		end
	end
	
	def destroy
		begin
			@feature = Feature.find(params[:id])
			@feature.destroy
		rescue=>e
			render :text => "An error has been occurred while deleting the feature #{e.class.name}: #{e.message}"
		end
	end
	
	def export
		begin
			@features = Feature.where(:id=>params[:feature_ids]).includes({:flows =>{:scenarios => :routes}}).joins({:flows =>{:scenarios => :routes}})
			file_name = Time.now.to_s<<".xml"
			response_xml = @features.to_xml(:include => {:flows => {:include => {:scenarios =>{:include =>:routes}}}})
			send_data response_xml, :type=>'xml', :disposition => 'attachment', :filename => 'Stubs_'<<file_name
		rescue=>e
			render :text=> "An error has been occurred while exporting the report!!! #{e.class.name}: #{e.message}"
		end
	end

	def import_json_index

	end

	def import_json
		begin
			file = params[:upload]
			if file['datafile'].content_type=="text/xml"
				store_json(file)
				File.delete("public/#{file['datafile'].original_filename}")
				render :text => "Yous stubs have been uploaded successfully!!!"
			else
				render :text => "Please upload a valid xml file!!!"
			end
		rescue=>e
			render :text => "An error has been occurred while importing the stubs!!! #{e.class.name}: #{e.message}"
		end
	end

	private
	 def feature_params
		params.require(:feature).permit(:feature_name)
	 end
end
