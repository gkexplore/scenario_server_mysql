module FeaturesHelper
	def store_json(file)
		directory ="public"
		path = File.join(directory,file['datafile'].original_filename)
		File.open(path,"wb"){|f| f.write(file['datafile'].read)}
		json_string = File.read("#{directory}/#{file['datafile'].original_filename}")
		proper_json = json_string.gsub('\"', '"')
		logs = JSON.parse(proper_json)
		logs.each do |feature|
			feature_model = Feature.find_or_initialize_by(:id=>feature['id'],:feature_name=>feature['feature_name'])
			feature_model.update(:id=>feature['id'],:feature_name=>feature['feature_name'])
			feature['flows'].each do |flow|
				flows = feature_model.flows.find_or_initialize_by(:flow_name=>flow['flow_name'])
				flows.update(:flow_name=>flow['flow_name'])
				flow['scenarios'].each do |scenario|
					scenarios = flows.scenarios.find_or_initialize_by(:scenario_name=>scenario['scenario_name'])
					scenarios.update(:scenario_name=>scenario['scenario_name'])
					scenario['routes'].each do |route|
						route = scenarios.routes.find_or_initialize_by(:route_type=>route['route_type'],:path=>route['request_url'],:request_body=>route['request_body'],:fixture=>route['response'],:status=>route['status'],:host=>route['host'])
						route.update(:route_type=>route['route_type'],:path=>route['request_url'],:request_body=>route['request_body'],:fixture=>route['response'],:status=>route['status'],:host=>route['host'])
					end
				end
			end
		end
	end
end
