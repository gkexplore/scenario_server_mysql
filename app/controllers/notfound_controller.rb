class NotfoundController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
     @notfound_list = Notfound.pluck(:device_ip).uniq
  end

  def notfound_list
  	begin
      if params[:device_ip].empty? || params[:device_ip].blank?
      	 @notfound_list = Notfound.all.reverse 
      else
         @notfound_list = Notfound.where(:device_ip=>params[:device_ip]) 
      end
      render layout: false
  	rescue=>e
  		flash[:danger] = "An error has been occurred while retrieving the device and scenario details"
  	end
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
