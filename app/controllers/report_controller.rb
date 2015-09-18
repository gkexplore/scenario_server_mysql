class ReportController < ApplicationController

  def report
  	#this implementation is in progress
  	  puts params[:device_ip]
  	  puts params[:testcase_name]
  end

  def testcase_status
  	#this implementation is in progress
 	   puts params[:device_ip]
 	   puts params[:testcase_name]
 	   puts params[:status]
  end

end
