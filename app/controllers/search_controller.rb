class SearchController < ApplicationController

  def search_scenario_index

  end

  def search_route_index

  end

  def search_scenario
      @search_result = Scenario.search(params[:query])
      render layout: false
  end

  def search_route
     # @search_result = Route.search(params[:query])
      @routes = Route.search do
          fulltext params[:query]
           keywords params[:query]
       end

       logger.debug @routes.results
      render layout: false
  end

end
