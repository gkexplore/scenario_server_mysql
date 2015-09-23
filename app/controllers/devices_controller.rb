	require 'socket' 
	require 'cgi'
	require 'json'
	require "net/http"
	require "uri"


	class DevicesController < ApplicationController

	use Rack::MethodOverride
	skip_before_filter :verify_authenticity_token
    include DevicesHelper

		def respond_to_app_client
			config =  Aadhiconfig.all
			case config[0].server_mode
				when SERVER_MODE::REFRESH
				when SERVER_MODE::RECORD
					method =  request.method
					make_request_to_actual_api(method,config)  
				else
					make_request_to_local_api_server
			end
		end


		def set_scenario
		    begin
			  @scenario = Scenario.find_by(:scenario_name=>params[:scenario_name])
			  if @scenario.blank?
			  		logger.debug "Invalid scenario: #{params[:scenario_name]}"
			    	render :json => { :status => '404', :message => 'Not Found'}, :status => 404
			  else
				    @device = Device.find_or_initialize_by(:device_ip=>params[:device_ip])
  					@device.update(scenario: @scenario)
  					render :json => { :status => 'Ok', :message => 'Received'}, :status => 200 
    		  end
    		rescue =>e
					logger.error "An error has been occurred in Set_Scenario #{e.class.name} : #{e.message}"
					render :json => { :status => '404', :message => 'Not Found'}, :status => 404
			end
		end

        private
		def make_request_to_actual_api(method, config)
			begin
			   	host, path, query, body = get_request_details
			    conn = Connection.new(host, config)
			    response = ""
			    case method
				    when METHOD::GET
				    	 response = conn.get(path, query, body, self.request)
				    when METHOD::POST
				     	 response = conn.post(path, query, body, self.request)
				    when METHOD::PUT
				      	 response = conn.put(path, query, body, self.request)
				    when METHOD::DELETE
				     	 response = conn.delete(path, query, body, self.request)
				end
			    render json: response.body, :status => response.code
			rescue=>e
				logger.error "An error has been occurred while hitting the API server!!! #{e.class.name} : #{e.message}"
				render :json => { :status => '404', :message => 'Not Found'}, :status => 404
			end  
		end


		private
		def make_request_to_local_api_server
			begin
				@device = Device.find_by(:device_ip=>get_ip_address)
				if @device.blank?
					log_notfound_request(get_path_query, request.method, get_ip_address)
					render :json => { :status => '404', :message => 'Not Found'}, :status => 404
				else
					@route = @device.scenario.routes.find_by(:path=>get_path_query, :route_type=>request.method)
					if @route.blank?
						log_notfound_request(get_path_query, request.method, get_ip_address, @device.scenario.scenario_name)
						render :json => { :status => '404', :message => 'Not Found'}, :status => 404
					else
						render json: @route.fixture, :status => @route.status
					end
				end
			rescue =>e
				logger.error "An error has been occurred in respond_to_client #{e.class.name} : #{e.message}"
				render :json => { :status => '404', :message => 'Not Found'}, :status => 404
			end
		end

		private 
		def get_request_details
			body = request.body.read
		    host_path = request.host + request.path
		    query = request.query_string
		    path_array = host_path.split("/")
		    path_array.delete_at(0)
		    host = request.env["rack.url_scheme"]+"://"+path_array[0]
		    path = get_path(host_path)
			[host, path, query, body] 
		end

		private 
		def get_ip_address
			remote_ip = request.remote_ip
			if remote_ip==DEFAULT_LOCALHOST
			 ip_address = LOCALHOST
			else
			 ip_address = remote_ip
			end
		end

		private 
		def get_path_query
			host_path = request.host + request.path
		   	query = request.query_string
		 	path = get_path(host_path)				
			url = URI.parse(request.url)
			sorted_string = Hash[request.query_parameters.sort]
			query = sorted_string.to_query
			if query.to_s.strip.length != 0
				query = "?"<<query
			end
			received_path = "#{path}#{query}"
		end

		private
		def get_path(host_path)
			path_array = host_path.split("/")
			path_array.delete_at(0)
			path_array.delete_at(0)
			if path_array.include? "http"
		       path_array.delete("http")
			end
		    final_path = ""
		    path_array.each do |t|
		      final_path<<"/"<<t
		    end
			path = final_path.gsub("//","/")
		end

		private 
		def log_notfound_request(url, method, ip_address, scenario_name="--")
			Notfound.create(:url=>url, :method=>method, :device_ip=>ip_address, :scenario_name=>scenario_name)
		end
	end










