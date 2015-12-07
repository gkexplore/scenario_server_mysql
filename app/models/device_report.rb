class DeviceReport < ActiveRecord::Base
	has_many:device_scenarios, dependent: :destroy
	def self.export_as_xml(device_ip)
      	  @reports = DeviceReport.where(:device_ip=>device_ip).includes({:device_scenarios =>:scenario_routes}).joins({:device_scenarios =>:scenario_routes})
      	  @reports.to_xml(:include=>[:device_scenarios =>{:include=>[:scenario_routes=>{:only => [:path, :route_type, :count]}]}])
    end
end
