class FeaturesController < ApplicationController
	#http_basic_authenticate_with name: "dhh", password: "secret", only: :index
	def index
		@features = Feature.all
	end
	def create
		@feature = Feature.new(feature_params)
  		@feature.save
  		redirect_to @feature
	end
	def new

	end
	def edit

	end
	def show
		@feature = Feature.find(params[:id])
	end
	def update
		
	end
	def destroy

	end
	private
	 def feature_params
		params.require(:feature).permit(:feature_name)
	 end
end
