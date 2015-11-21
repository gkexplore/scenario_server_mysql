class ReportController < ApplicationController
  include ReportsHelper

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

	def import_report

	end

	def upload_report
		begin
        file = params[:upload]
        logger.debug "content type is:::"+file['datafile'].content_type
        if file['datafile'].content_type=="text/xml" || file['datafile'].content_type=="application/xml"
          upload_report_xml(file)
          File.delete("public/#{file['datafile'].original_filename}")
          flash[:success] = "The report has been uploaded successfully!!!"
          redirect_to '/report/index'
        else
          flash.now[:warning] = "Please upload a valid xml file!!!"
          render :json => { :status => '400', :message => 'Please upload a valid xml file'}, :status => 400
        end
    rescue=>e
        flash[:danger] = 'An error has been occurred while uploading the report!!!'
        redirect_to '/report/index'
		end
	end

end
