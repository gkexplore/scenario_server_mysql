class AadhiconfigController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def index
		begin
			@configs = Aadhiconfig.all
			if @configs.blank? || @configs.empty? | @configs.nil? 
				Aadhiconfig.create(:server_mode=>"default")
				@configs = Aadhiconfig.all
			end
		rescue=>e
			flash[:error] = "An error has been occurred while retrieving the configs #{e.class.name}: #{e.message}"
		end
	end

	def update
		begin
			@config = Aadhiconfig.find(params[:id])
			if @config.update(config_params)
			   @configs = Aadhiconfig.all
			   flash[:success] = "The config has been updated successfully!!!"
			   render 'index'
			end
		rescue=>e
			flash[:error] = "An error has been occurred while updating the server mode #{e.class.name}: #{e.message}"
			redirect_to '/adhiconfig'
		end
	end

	private
	 def config_params
		params.require(:aadhiconfig).permit(:server_mode,:isProxyRequired,:url,:port,:user,:password,:bypass_proxy_domains)
	 end

end
