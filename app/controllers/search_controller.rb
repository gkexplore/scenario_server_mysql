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
      @search_result = Route.search(params[:query])
      render layout: false
  end

end
