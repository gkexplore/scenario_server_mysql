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
			@features = Feature.where(:id=>params[:feature_ids]).includes({:flows =>{:scenarios => :routes}}).joins({:flows =>{:scenarios => :routes}})
			file_name = Time.now.to_s<<".yaml"
			@features.as_json.to_yaml
			send_data @features.as_json.to_yaml, :type=>'yaml', :disposition => 'attachment', :filename => 'Stubs_'<<file_name
	end

	def import_json_index

	end

	def import_json
		file = params[:upload]
		begin
			store_json(file)
			File.delete("public/#{file['datafile'].original_filename}")
		rescue=>e
			puts "An error has been occurred while importing the data!!! #{e.class.name}: #{e.message}"
		end
		redirect_to '/'
	end

	private
	 def feature_params
		params.require(:feature).permit(:feature_name)
	 end
end
