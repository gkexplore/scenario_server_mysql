class FeaturesController < ApplicationController
	#http_basic_authenticate_with name: "dhh", password: "secret", only: :index
	 skip_before_filter :verify_authenticity_token
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
			file_name = Time.now.to_s<<".json"
			send_data @features.as_json.to_json, :type=>'json', :disposition => 'attachment', :filename => 'Stubs_'<<file_name
	end
	private
	 def feature_params
		params.require(:feature).permit(:feature_name)
	 end
end
