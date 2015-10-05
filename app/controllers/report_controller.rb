class ReportController < ApplicationController

  def report
  	  @device_list = DeviceReport.all
  end

  def export
  	  if params[:device_ip].nil? || params[:device_ip].empty? || params[:device_ip].blank?
  	  	 render :json => { :status => '404', :message => 'No Record Found'}, :status => 404
  	  else
  	  	 @device = DeviceReport.find_by(:device_ip=>params[:device_ip])
  	  	    if @device.blank?
  	  	    	render :json => { :status => '404', :message => 'No Record Found'}, :status => 404
  	  	    else
  	 			 file_name = Time.now.to_s<<".xml"
	  			 send_data DeviceReport.export_as_xml(params[:device_ip]), :type=>'xml', :disposition => 'attachment', :filename => 'Reports_'<<file_name	
 	  		end
 	  end
  end

end
