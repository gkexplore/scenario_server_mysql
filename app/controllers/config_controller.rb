class ConfigController < ApplicationController
  def index
		begin
			@configs = Config.all
		rescue=>e
			render :text =>"An error has been occurred while retrieving all the features #{e.class.name}: #{e.message}"
		end
	end
	def update
		begin
			@config = Config.find(params[:id])
			  if @config.update(config_params)
			  	@configs = Config.all
			    render action: "index"
			   end
		rescue=>e
			render :text => "An error has been occurred while updating the feature #{e.class.name}: #{e.message}"
		end
	end
	private
	 def config_params
		params.require(:config).permit(:server_mode)
	 end
end
