class Route < ActiveRecord::Base
  belongs_to :scenario

  def self.save_route(scenario, params)
	  params[:path] = sort_query_parameters("http://localhost"+params[:path])
	  route = scenario.routes.create(params)
  end
  
  def self.update_route(route, params)
  	  params[:path] = sort_query_parameters("http://localhost"+params[:path])
  	  route.update(params)
  end
end
