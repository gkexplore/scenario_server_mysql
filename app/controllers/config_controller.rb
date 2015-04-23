class ConfigController < ApplicationController
  def index
  	puts "Inside index"
		begin
			@configs = Config.all
		rescue=>e
			render :text =>"An error has been occurred while retrieving all the features #{e.class.name}: #{e.message}"
		end
	end
end
