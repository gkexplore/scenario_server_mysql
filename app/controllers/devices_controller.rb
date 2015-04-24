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

		puts config[0].server_mode

		case config[0].server_mode

			when SERVER_MODE::REFRESH
				
				puts "hello refresh"
			
			when SERVER_MODE::RECORD
			
				case request.method
			
				when "GET"
			 		

			 		logger.warn "*** BEGIN RAW REQUEST HEADERS ***"
self.request.env.each do |header|
  logger.warn "HEADER KEY: #{header[0]}"
  logger.warn "HEADER VAL: #{header[1]}"
end
logger.warn "*** END RAW REQUEST HEADERS ***"
					  # => Hash
					 
					# => http


					    puts "** host: " + request.host
					    puts "** path: " + request.path

					    host_path = request.host + request.path
					    query = request.query_string
					    path_array = host_path.split("/")
					    path_array.delete_at(0)
					    host = path_array[0]<<"://"<<path_array[1]
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
					   
					   make_get_request(host, path, query,headers)
					   

				when "POST"

				      headers = JSON.parse( JSON.generate(request.env) )
					  puts  headers.class
					  # => Hash
					  puts headers["rack.url_scheme"]
					# => http

					    puts "** host: " + request.host
					    puts "** path: " + request.path
					    body = request.body.read
					    host_path = request.host + request.path
					    query = request.query_string
					    path_array = host_path.split("/")
					    path_array.delete_at(0)
					    host = path_array[0]<<"://"<<path_array[1]
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
					   body make_post_request(host, path, query, body, headers)

				when "PUT"
							  
					  headers = JSON.parse( JSON.generate(request.env) )
					  puts  headers.class
					  # => Hash
					  puts headers["rack.url_scheme"]
					# => http

					    puts "** host: " + request.host
					    puts "** path: " + request.path
					    body = request.body.read
					    host_path = request.host + request.path
					    query = request.query_string
					    path_array = host_path.split("/")
					    path_array.delete_at(0)
					    host = path_array[0]<<"://"<<path_array[1]
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
					   body make_put_request(host, path, query, body, headers)

				when "DELETE"
						headers = JSON.parse( JSON.generate(request.env) )
						puts headers
						puts  headers.class
						  # => Hash
						puts headers["rack.url_scheme"]
						# => http


					    puts "** host: " + request.host
					    puts "** path: " + request.path

					    host_path = request.host + request.path
					    query = request.query_string
					    path_array = host_path.split("/")
					    path_array.delete_at(0)
					    host = path_array[0]<<"://"<<path_array[1]
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
					   body make_delete_request(host, path, query,headers)
				else
							puts "inside else"
				end
			else

				begin
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
					received_path = "/#{params[:path]}#{query}"
					@device = Device.find_by(:device_ip=>ip_address)	
					if @device.blank?
						render :json => { :status => '404', :message => 'Not Found'}, :status => 404
					else
						@route = @device.scenario.routes.find_by(:path=>received_path,:route_type=>request.method)
						render json: @route.fixture, :status => 200
					end
				rescue =>e
					logger.error "An error has been occurred in respond_to_CMA_client #{e.class.name} : #{e.message}"
					render :json => { :status => '404', :message => 'Not Found'}, :status => 404
				end	
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

	def local_ip
	  orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  # turn off reverse DNS resolution temporarily
	  UDPSocket.open do |s|
	    s.connect '64.233.187.99', 1
	    s.addr.last
	  end
	ensure
	  Socket.do_not_reverse_lookup = orig
	end

def get_connection(host)
  conn = Faraday.new(:url => host) do |c|
      c.use Faraday::Request::UrlEncoded  
      c.use Faraday::Response::Logger     
      c.use Faraday::Adapter::NetHttp     
    end
  return conn
end


def make_get_request(host, path, query, headers)
    conn = get_connection(host)
    puts host<<path<<"?"<<query 
    response = conn.get do |req|
        req.url path<<"?"<<query   
        req.headers["Content_Type"]="application/json"


        	self.request.env.each do |header|
          final_key = header[0].downcase
          if (final_key.include?("http_") && !final_key.include?("http_host") && !final_key.include?("http_cookie"))
            puts "key:-"+final_key+"  value:-"+header[1]
            final_key.slice!'http_'
            puts "final_key:"+final_key
            req.headers[final_key]=header[1]
          elsif(final_key.include?("content_type"))
            puts "Inside else"
            req.headers["Content_Type"]="#{header[1]}"
          end
         end

         end
    
         render json: response.body, :status => response.status
end


def make_post_request(host,path,query,body,headers)
      conn = get_connection(host)
      response = conn.post do |req|
      req.url path<<"?"<<query 
      req.headers["Content-Type"]="application/json"
        headers.each do |key, value|
          final_key = key.downcase
          if (final_key.include?("http_") && !final_key.include?("http_host") && !final_key.include?("http_cookie"))
            puts "key:-"+final_key+"  value:-"+value
            final_key.slice!'http_'
            puts "final_key:"+final_key
            req.headers[final_key]=value
          elsif(final_key.include?("content_type"))
            puts "Inside else"
            req.headers["Content-Type"]=value
          end
         end
      req.body = body
    end
   render json: response.body, :status => response.status
end

def make_delete_request(host, path, query, headers)
    conn = get_connection(host)
    puts host<<path<<"?"<<query 
    response = conn.delete do |req|
        req.url path<<"?"<<query   
        req.headers["Content_Type"]="application/json"
         headers.each do |key, value|
          final_key = key.downcase
          if (final_key.include?("http_") && !final_key.include?("http_host") && !final_key.include?("http_cookie"))
            puts "key:-"+final_key+"  value:-"+value
            final_key.slice!'http_'
            puts "final_key:"+final_key
            req.headers[final_key]=value
          elsif(final_key.include?("content_type"))
             puts "Inside else"
            req.headers["Content_Type"]=value
          end

         end
    end  
    response.body
end

def make_put_request(host,path,query,body,headers)
    conn = get_connection(host)
      response = conn.put do |req|
      req.url path<<"?"<<query 
      req.headers["Content-Type"]="application/json"
        headers.each do |key, value|
          final_key = key.downcase
          if (final_key.include?("http_") && !final_key.include?("http_host") && !final_key.include?("http_cookie"))
            puts "key:-"+final_key+"  value:-"+value
            final_key.slice!'http_'
            puts "final_key:"+final_key
            req.headers[final_key]=value
          elsif(final_key.include?("content_type"))
            puts "Inside else"
            req.headers["Content-Type"]=value
          end
         end
      req.body = body
    end
    render json: response.body, :status => response.status
end
end

