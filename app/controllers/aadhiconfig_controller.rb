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
			 alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while retrieving the configs #{e.class.name}: #{e.message}", "/adhiconfig", AadhiConstants::ALERT_BUTTON)
		end
	end
	def update
		begin
			@config = Aadhiconfig.find(params[:id])
			  if @config.update(config_params)
			  	@configs = Aadhiconfig.all
	    		alert(AadhiConstants::ALERT_CONFIRMATION, "The config has been updated successfully!!!", "/aadhiconfig", AadhiConstants::ALERT_BUTTON)
			   end
		rescue=>e
			alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while updating the server mode #{e.class.name}: #{e.message}", "/adhiconfig", AadhiConstants::ALERT_BUTTON)
		end
	end
	private
	 def config_params
		params.require(:aadhiconfig).permit(:server_mode,:isProxyRequired,:url,:port,:user,:password,:bypass_proxy_domains)
	 end
end
