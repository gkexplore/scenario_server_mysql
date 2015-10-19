
class Stub < ActiveRecord::Base

include AadhiModelUtil

	def self.save_stubs(feature_name, flow_name, scenario_name)

		feature_model = Feature.find_or_initialize_by(:feature_name=>feature_name)
        feature_model.update(:feature_name=>feature_name)
        flows = feature_model.flows.find_or_initialize_by(:flow_name=>flow_name)
        flows.update(:flow_name=>flow_name)
        scenarios = flows.scenarios.find_or_initialize_by(:scenario_name=>scenario_name)
        scenarios.update(:scenario_name=>scenario_name) 
        @stubs = Stub.all.reverse
        @stubs.each do |route|
            request_url = route.request_url
            routes = scenarios.routes.find_or_initialize_by(:path=>sort_query_parameters(request_url), :route_type=>route.route_type)
            routes.update(:route_type=>route.route_type, :path=>sort_query_parameters(request_url), :request_body=>route.request_body, :fixture=>route.response, :status=>route.status, :host=>route.host)  
        end    
          
	end

end
