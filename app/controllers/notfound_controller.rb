class NotfoundController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
     @notfound_list = Notfound.pluck(:device_ip).uniq
  end

  def notfound_list
      unless params[:device_ip].nil? || params[:device_ip].blank?
          @notfound_list = Notfound.find_notfound_requests(params[:device_ip]) 
      end
      render layout: false
  end

  def clear_notfound_list
  	begin
    	Notfound.delete_all
    	flash[:success] = "All the record have been cleared successfully!!!"
    	redirect_to '/notfound'
 	  rescue Exception=>e
       	flash[:danger] = "An error has been occurred while deleting the notfound list #{e.class.name}: #{e.message}"
       	redirect_to '/notfound'
  		end
  end

end
