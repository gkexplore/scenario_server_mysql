class SearchController < ApplicationController

  def search_scenario_index
     
  end

  def search_route_index
     @search_result = Route.search do
        fulltext params[:query]
        with(:path, params[:path]) unless params[:path].blank?
        with(:route_type, params[:route_type]) unless params[:route_type].blank?
        facet :path
        facet :route_type
        paginate :page => params[:page], :per_page => 20
     end
  end

  def search_scenario
      @search_result = Scenario.search(params[:query])
      render layout: false
  end

  def search_route
     # @search_result = Route.search(params[:query])
      @search_result = Route.search do
          fulltext params[:query]
          with(:path, params[:path]) unless params[:path].blank?
          facet :path
       end

      # logger.debug @routes.results
      render layout: false
  end

end
