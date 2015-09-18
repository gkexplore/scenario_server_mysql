class ReportController < ApplicationController

  def report
  	  puts params[:device_ip]
  	  puts params[:testcase_name]
  end

  def testcase_status
 	   puts params[:device_ip]
 	   puts params[:testcase_name]
 	   puts params[:status]
  end

end
