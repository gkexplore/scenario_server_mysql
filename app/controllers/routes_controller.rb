class RoutesController < ApplicationController
	skip_before_action :verify_authenticity_token
	def index

	end
	def create
		begin
			@feature = Feature.find(params[:feature_id])
	    	@flow = @feature.flows.find(params[:flow_id])
	    	@scenario = @flow.scenarios.find(params[:scenario_id])
	    	params = route_params
			params[:path] = sort_query_parameters(params)
	    	@route = @scenario.routes.create(params)
	    	render "scenarios/show"
	    rescue=>e	
			alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while creating the route #{e.class.name}: #{e.message}", "", AadhiConstants::ALERT_BUTTON) 
		end
	end
	def new

	end
	def edit
		begin
			@feature = Feature.find(params[:feature_id])
			@flow = @feature.flows.find(params[:flow_id])
			@scenario = @flow.scenarios.find(params[:scenario_id])
			@route = @scenario.routes.find(params[:id])
		rescue=>e
			alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while editing the route #{e.class.name}: #{e.message}", "", AadhiConstants::ALERT_BUTTON) 
		end
	end
	def show
		begin
			@feature = Feature.find(params[:feature_id])
			@flow = @feature.flows.find(params[:flow_id])
			@scenario = @flow.scenarios.find(params[:scenario_id])
			@route = @scenario.routes.find(params[:id])
		rescue=>e
			alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while retrieving the route #{e.class.name}: #{e.message}", "", AadhiConstants::ALERT_BUTTON) 
		end
	end
	def update
		begin
			@feature = Feature.find(params[:feature_id])
			@flow = @feature.flows.find(params[:flow_id])
			@scenario = @flow.scenarios.find(params[:scenario_id])
			@route = @scenario.routes.find(params[:id])
			params = route_params
			params[:path] = sort_query_parameters(params)
			  if @route.update(params)
			    render "scenarios/show"
			  else
			    render 'routes/edit'
			  end
		rescue=>e
			alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while updating the route #{e.class.name}: #{e.message}", "", AadhiConstants::ALERT_BUTTON) 
		end
	end
	def destroy
		begin
			@feature = Feature.find(params[:feature_id])
			@flow = @feature.flows.find(params[:flow_id])
			@scenario = @flow.scenarios.find(params[:scenario_id])
			@route = @scenario.routes.find(params[:id])
			@route.destroy
			render "scenarios/show"
		rescue=>e
			alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while deleting the route #{e.class.name}: #{e.message}", "", AadhiConstants::ALERT_BUTTON) 
		end
	end
	private
	 def route_params
		params.require(:route).permit(:route_type,:path,:query,:request_body,:fixture,:status,:host)
	 end
	private
	 def qs_to_hash(querystring)
		  keyvals = querystring.split('&').inject({}) do |result, q| 
		    k,v = q.split('=')
		    if !v.nil?
		       result.merge({k => v})
		    elsif !result.key?(k)
		      result.merge({k => true})
		    else
		      result
		    end
		  end
		  keyvals
	end
	private
	def sort_query_parameters(params)
		path_query = params[:path]
    	temp_url = URI.parse("http://localhost:9090"+path_query)
    	query = temp_url.query
    	if query==nil || query=='' || query.blank?
    		path = temp_url.path.downcase
    	else
	    	puts "query ***"+query
	    	path = temp_url.path.downcase
			hash_string = qs_to_hash(query)
			sorted_string =  Hash[hash_string.sort]
			final_sorted_string = sorted_string.to_query
			if final_sorted_string.to_s.strip.length != 0
				final_sorted_string = "?"+final_sorted_string
			end
			path+final_sorted_string
		end
	end

end
