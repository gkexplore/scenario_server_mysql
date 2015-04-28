require 'socket' 
require 'cgi'
require 'json'
require 'faraday'

class DevicesController < ApplicationController

use Rack::MethodOverride
skip_before_filter :verify_authenticity_token

include DevicesHelper

	def respond_to_app_client
		config =  Config.all
		case config[0].server_mode
			when SERVER_MODE::REFRESH	
				#add refresh implementation here	
			when SERVER_MODE::RECORD
				method =  request.method
				make_request_to_actual_api(method)  
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

def make_request_to_actual_api(method)
   		body = request.body.read
   		host_path = request.host + request.path
	    query = request.query_string
	    path_array = host_path.split("/")
	    path_array.delete_at(0)
	    host = request.env["rack.url_scheme"]+"://"+path_array[0]
   		path = get_path(host_path)
	    conn = get_connection(host)	
	    response = ""
	    case method
		    when METHOD::GET
		       response = conn.get do |req|
		       form_request_headers_and_hit_api(req,path,query,body)
		    end
		    when METHOD::POST

		       response = conn.post do |req|
		       form_request_headers_and_hit_api(req,path,query,body)
		    end
		    when METHOD::PUT
		       response = conn.put do |req|
		       form_request_headers_and_hit_api(req,path,query,body)
		    end
		    when METHOD::DELETE
		       response = conn.delete do |req|
		       form_request_headers_and_hit_api(req,path,query,body)
		    end
	    end

		@route = Stub.create(:request_url=>host+path, :route_type=>method, :request_body=>body, :response=>response.body, :status=>response.status, :host=>host)
	    if @route.save 
	  		 puts "saved"
		end
		
	  render json: response.body, :status => response.status
	end

	def form_request_headers_and_hit_api(req,path,query,body)
	 req.url path<<"?"<<query   
        req.headers["Content-Type"]="application/json"
        self.request.env.each do |header|
        	final_key = header[0].downcase
         	 if (final_key.include?("http_") && !final_key.include?("http_host") && !final_key.include?("http_cookie"))	
           		 final_key.slice!'http_'
           		 req.headers[final_key]=header[1]
         	 elsif(final_key.include?("content-type"))
            	 req.headers["Content-Type"]="#{header[1]}"
          	 end
          end
        req.body = body
    end


	def get_connection(host)
	  conn = Faraday.new(:url => host) do |c|
	      c.use Faraday::Request::UrlEncoded  
	      c.use Faraday::Response::Logger     
	      c.use Faraday::Adapter::NetHttp     
	    end
	  return conn
	end

	def make_request_to_local_api_server
		begin
	   		host_path = request.host + request.path
		    query = request.query_string
	   		path = get_path(host_path)
			remote_ip = request.remote_ip
			if remote_ip=="::1"
				ip_address = "127.0.0.1"
			else
				ip_address = remote_ip
			end
			url = URI.parse(request.url)
			sorted_string = Hash[request.query_parameters.sort]
			query = sorted_string.to_query
			if query.to_s.strip.length != 0
				query = "?"<<query
			end
			received_path = "#{path}#{query}"
			@device = Device.find_by(:device_ip=>ip_address)	
			if @device.blank?
				render :json => { :status => '404', :message => 'Not Found'}, :status => 404
			else
				@route = @device.scenario.routes.find_by(:path=>received_path,:route_type=>request.method)
				if @route.blank?
					render :json => { :status => '404', :message => 'Not Found'}, :status => 404
				else
					render json: @route.fixture, :status => 200
				end
			end
		rescue =>e
			logger.error "An error has been occurred in respond_to_CMA_client #{e.class.name} : #{e.message}"
			render :json => { :status => '404', :message => 'Not Found'}, :status => 404
		end	
	end

	def get_path(host_path)
			 path_array = host_path.split("/")
			 path_array.delete_at(0)
			 path_array.delete_at(0)
			 if path_array.include? "http"
			    path_array.delete("http")
			 end
		    final_path =""
		    path_array.each do |t|
		      final_path<<"/"<<t
		    end
			path = final_path.gsub("//","/")
	end

end

class Route_R
	attr_accessor :id, :request_url, :route_type, :request_body, :response, :status, :host
	def initialize(id = nil, request_url = nil, route_type = nil, request_body = nil, response = nil, status = 200, host = nil)
		self.id = id
		self.request_url = request_url
		self.route_type = route_type
		self.request_body = request_body
		self.response =  response
		self.status = status
		self.host = host
	end
end