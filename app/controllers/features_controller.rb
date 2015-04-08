class FeaturesController < ApplicationController

	#http_basic_authenticate_with name: "dhh", password: "secret", only: :index
	 skip_before_filter :verify_authenticity_token
	 include FeaturesHelper
	def index
		@features = Feature.all
	end

	def create
		@feature = Feature.new(feature_params)
  		if @feature.save
  			redirect_to @feature
  		else
  			render 'new'
  		end
	end
	
	def new
		@feature = Feature.new
	end
	
	def edit
		@feature = Feature.find(params[:id])
	end
	
	def show
		@feature = Feature.find(params[:id])
	end
	
	def update
		@feature = Feature.find(params[:id])
		  if @feature.update(feature_params)
		    redirect_to @feature
		  else
		    render 'edit'
		  end
	end
	
	def destroy

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
		file = params[:upload]
		begin
			store_json(file)
			File.delete("public/#{file['datafile'].original_filename}")
			render :text => "You report stubs have been uploaded successfully!!!"
		rescue=>e
			render :text => "An error has been occurred while importing the stubs!!! #{e.class.name}: #{e.message}"
		end
	end

	private
	 def feature_params
		params.require(:feature).permit(:feature_name)
	 end
end
