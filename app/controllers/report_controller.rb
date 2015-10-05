class ReportController < ApplicationController

  def report
  	  @device_list = DeviceReport.all
  end

  def export
  	  file_name = Time.now.to_s<<".xml"
	  send_data DeviceReport.export_as_xml(params[:device_ip]), :type=>'xml', :disposition => 'attachment', :filename => 'Reports_'<<file_name	
  end

end
