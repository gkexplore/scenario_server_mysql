class Route < ActiveRecord::Base
  belongs_to :scenario
  after_update :flush_route_hash

  def self.save_route(scenario, params)
	  params[:path] = sort_query_parameters("http://localhost"+params[:path])
	  route = scenario.routes.create(params)
  end
  
  def self.update_route(route, params)
  	  params[:path] = sort_query_parameters("http://localhost"+params[:path])
  	  route.update(params)
  end

  def self.save_routes(feature_name, flow_name, scenario_name, routes)
		feature_model = Feature.find_or_initialize_by(:feature_name=>feature_name)
        feature_model.update(:feature_name=>feature_name)
        flows = feature_model.flows.find_or_initialize_by(:flow_name=>flow_name)
        flows.update(:flow_name=>flow_name)
        scenarios = flows.scenarios.find_or_initialize_by(:scenario_name=>scenario_name)
        scenarios.update(:scenario_name=>scenario_name) 
        routes.each do |route|
            route_found = scenarios.routes.find_or_initialize_by(:path=>route.path, :route_type=>route.route_type)
            route_found.update(:route_type=>route.route_type, :path=>route.path, :request_body=>route.request_body, :fixture=>route.fixture, :status=>route.status, :host=>route.host)  
        end    
  end

  def self.save_routes_to_scenario(routes, scenarios)
      scenarios.each do |scenario|
        routes.each do |route|
            route_found = scenario.routes.find_or_initialize_by(:path=>route.path, :route_type=>route.route_type)
            route_found.update(:route_type=>route.route_type, :path=>route.path, :request_body=>route.request_body, :fixture=>route.fixture, :status=>route.status, :host=>route.host)  
        end 
      end   
  end

  def self.save_to_replace(scenarios)
      scenarios.each do |scenario|
          scenario.update(:isTemp=>"yes")
      end   
  end

  def self.search(query)
    where("path like ?", "%#{query}%")
  end

  def flush_route_hash
     Rails.cache.delete([:scenario, scenario_id, path, route_type.upcase])
  end

end
