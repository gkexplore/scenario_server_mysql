class FeaturesController < ApplicationController

	#http_basic_authenticate_with name: "dhh", password: "secret", only: :index
	 skip_before_filter :verify_authenticity_token

	include FeaturesHelper
	
	def index
		begin
			@features = Feature.order("feature_name ASC")
			@flows = Flow.all
			@scenarios = Scenario.all
		rescue=>e
			flash[:danger] = "An error has been occurred while retrieving all the features #{e.class.name}: #{e.message}"
		end
	end

	def create
		begin
			@feature = Feature.new(feature_params)
  			if @feature.save
  				flash[:success] = "The feature has been created successfully!!!"
  				redirect_to @feature
  			end
  		rescue=>e
			flash.now[:danger] = "An error has been occurred while creating the feature!!!"
	  		render 'new'
  		end
	end
	
	def new
		begin
			@feature = Feature.new
		rescue=>e
			flash[:danger] = "An error has been occurred while creating new instance for a feature #{e.class.name}: #{e.message}"
		end
	end
	
	def edit
		begin
			@feature = Feature.find(params[:id])
		rescue=>e
			flash[:danger] = "An error has been occurred while editing the feature #{e.class.name}: #{e.message}"
		end
	end
	
	def show
		@feature = Feature.find(params[:id])
	end
	
	def update
		begin
		  @feature = Feature.find(params[:id])
		  if @feature.update(feature_params)
		  	flash[:success] = "The feature has been updated successfully!!!"
		    redirect_to @feature
		  end
		rescue=>e
			flash.now[:danger] = "An error has been occurred while updating the feature!!!"
			render 'edit'
		end
	end
	
	def destroy
		begin
			@feature = Feature.find(params[:id])
			@feature.destroy
			flash[:success] = "The selected feature has been deleted successfully!!!"
			redirect_to '/features'
  		rescue=>e
  			flash[:danger] = "An error has been occurred while deleting the feature #{e.class.name}: #{e.message}"
  			redirect_to '/features'
		end
	end
	
	def export
		begin
			if params[:commit] == 'Export Selected'
				file_name = Time.now.to_s<<".xml"
				send_data Feature.export_as_xml(params[:feature_ids]), :type=>'xml', :disposition => 'attachment', :filename => 'Stubs_'<<file_name
			elsif params[:commit] == 'Delete Selected'
				 Feature.destroy(params[:feature_ids])
				 flash[:success] = "The selected features have been deleted successfully!!!"
				 redirect_to '/features'
			end
		rescue=>e
			flash[:danger] = "An error has been occurred while exporting/deleting the report!!! #{e.class.name}: #{e.message}"
			redirect_to '/features'
		end
	end

	def export_all
		begin
			file_name = Time.now.to_s<<".xml"
			send_data Feature.export_all_as_xml, :type=>'xml', :disposition => 'attachment', :filename => 'Stubs_'<<file_name
		rescue=>e
			flash[:danger] = "An error has been occurred while exporting the report!!! #{e.class.name}: #{e.message}"
			redirect_to '/features'
		end
	end

	def delete_all 
		begin	
		 @features = Feature.all	
		 @features.each do |feature|
			feature.destroy
		 end
		 flash[:success] = "All feature have been deleted successfully !!!"
		 redirect_to '/features'
		rescue=>e
		 flash[:danger] = "An error has been occurred while delete all features!!! #{e.class.name}: #{e.message}"
		 redirect_to '/features'
		end			
	end

	def import_xml_index
	end

	def import_xml
		begin
			file = params[:upload]
			logger.debug "content type is:::"+file['datafile'].content_type
			if file['datafile'].content_type=="text/xml" || file['datafile'].content_type=="application/xml"
				store_xml(file)
				File.delete("public/#{file['datafile'].original_filename}")
				flash[:success] = "Your stubs have been uploaded successfully!!!"
				redirect_to '/features'
			else
				flash.now[:warning] = "Please upload a valid xml file!!!"
				render 'import_xml_index'
			end
		rescue=>e
				flash.now[:danger] = "An error has been occurred while importing the stubs!!!"
				render 'import_xml_index'
		end
	end

	def upload_stubs
		begin
			file = params[:upload]
			logger.debug "content type is:::"+file['datafile'].content_type
			if file['datafile'].content_type=="text/xml" || file['datafile'].content_type=="application/xml"
				store_xml(file)
				File.delete("public/#{file['datafile'].original_filename}")
				render :json => { :status => 'Ok', :message => 'Received'}, :status => 200 
			else
				flash.now[:warning] = "Please upload a valid xml file!!!"
				render :json => { :status => '400', :message => 'Please upload a valid xml file'}, :status => 400 
			end
		rescue=>e
				render :json => { :status => '404', :message => 'An error has been occurred while uploading stubs'}, :status => 404 
		end
	end

	private
	 def feature_params
		params.require(:feature).permit(:feature_name)
	 end
end
