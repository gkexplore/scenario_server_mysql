class DeviceReport < ActiveRecord::Base
	has_many:device_scenarios, dependent: :delete_all
end
