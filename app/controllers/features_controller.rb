class FeaturesController < ApplicationController
	#http_basic_authenticate_with name: "dhh", password: "secret", only: :index
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
	private
	 def feature_params
		params.require(:feature).permit(:feature_name)
	 end
end
