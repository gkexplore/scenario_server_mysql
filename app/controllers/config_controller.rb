class ConfigController < ApplicationController
	skip_before_filter :verify_authenticity_token
  def index
		begin
			@configs = Config.all
			if @configs.blank? || @configs.empty? | @configs.nil? 
				Config.create(:server_mode=>"default")
				@configs = Config.all
			end
		rescue=>e
			 alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while retrieving the configs #{e.class.name}: #{e.message}", "/config", AadhiConstants::ALERT_BUTTON)
		end
	end
	def update
		begin
			@config = Config.find(params[:id])
			  if @config.update(config_params)
			  	@configs = Config.all
	    		alert(AadhiConstants::ALERT_CONFIRMATION, "The config has been updated successfully!!!", "/config", AadhiConstants::ALERT_BUTTON)
			   end
		rescue=>e
			alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while updating the server mode #{e.class.name}: #{e.message}", "/config", AadhiConstants::ALERT_BUTTON)
		end
	end
	private
	 def config_params
		params.require(:config).permit(:server_mode,:isProxyRequired,:url,:port,:user,:password)
	 end
end
