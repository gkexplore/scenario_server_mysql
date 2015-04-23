class ConfigurationController < ApplicationController
  def index
  	puts "inside config controller"
		begin
			@configs = Config.all
		rescue=>e
			render :text =>"An error has been occurred while retrieving all the features #{e.class.name}: #{e.message}"
		end
	end
end
