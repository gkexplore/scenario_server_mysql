class ReportController < ApplicationController

  def report
  	  @device_list = DeviceReport.all
  end

end
