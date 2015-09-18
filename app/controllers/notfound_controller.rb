class NotfoundController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
  	@notfound_list = Notfound.all
  end

  def notfound_list
	begin
		@notfound_list = Notfound.all.reverse
		render layout: false
	rescue=>e
		flash[:error] = "An error has been occurred while retrieving the device and scenario details"
	end
  end

  def clear_notfound_list
  	begin
    	Notfound.delete_all
    	flash[:success] = "All the record have been cleared successfully!!!"
    	redirect_to '/notfound'
 	  rescue Exception=>e
       	flash[:error] = "An error has been occurred while deleting the notfound list #{e.class.name}: #{e.message}"
       	redirect_to '/notfound'
  		end
  end

end
