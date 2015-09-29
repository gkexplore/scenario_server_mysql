class DeviceScenario < ActiveRecord::Base
  has_many:scenario_routes, dependent: :delete_all
  belongs_to :device_report 
end
