	require 'socket' 
	require 'cgi'
	require 'json'
	require "net/http"
	require "uri"

  class DevicesController < ApplicationController

	use Rack::MethodOverride

	skip_before_filter :verify_authenticity_token

    include DevicesHelper
    include AadhiModelUtil

    def status
     	render :json => { :status => 'Ok', :message => 'Received'}, :status => 200
    end

    def delete_report
		@device = DeviceReport.find_by(:device_ip=>params[:device_ip])
		unless @device.blank?
			@device.device_scenarios.each do |device_scenario|
				device_scenario.destroy
			end
			@device.destroy
		end
		render :json => { :status => 'Ok', :message => 'Received'}, :status => 200
    end

    def clear_all_logs
    	begin
    		Notfound.delete_all
    		File.truncate('/var/www/scenario_server_mysql/log/development.log', 0)
    		File.truncate('/var/www/scenario_server_mysql/log/production.log', 0)
    		render :json => { :status => 'Ok', :message => 'All the logs have been cleared successfully!!!'}, :status => 200
    	rescue=>e
    		render :json => { :status => '404', :message => 'An error has been occurred while clearing the logs!!!'}, :status => 404
    	end
    end

    def set_default_mode
    	begin
	    	@configs = Aadhiconfig.all
	    	@configs[0].update(:server_mode=>"default")
	    	render :json => { :status => 'Ok', :message => 'The server mode has been set to default!!!'}, :status => 200
	    rescue=>e
    		render :json => { :status => '404', :message => 'An error has been occurred while setting the default server mode!!!'}, :status => 404
    	end
    end

	def respond_to_app_client
		log_device_ip
		config =  Aadhiconfig.all
		case config[0].server_mode
			when SERVER_MODE::REFRESH
			when SERVER_MODE::RECORD
				method =  request.method
				make_request_to_actual_api(method,config)  
			else
				@device = Device.find_by(:device_ip=>get_ip_address)
				if @device.blank?
					render :json => { :status => '404', :message => 'Not Found'}, :status => 404
				else
					if @device.isReportRequired=='yes'
					   make_request_to_local_api_server(true)
					else
						make_request_to_local_api_server
				    end
				end
			end
	end


	def set_scenario
	    begin
	      @configs = Aadhiconfig.all
	      @configs[0].update(:server_mode=>"default")
		  @scenario = Scenario.find_by(:scenario_name=>params[:scenario_name])
		  if @scenario.blank?
		  		logger.fatal "Invalid scenario: #{params[:scenario_name]} \n"
		    	render :json => { :status => '404', :message => 'Not Found'}, :status => 404
		  else
			    @device = Device.find_or_initialize_by(:device_ip=>params[:device_ip])
			    if params[:isReportRequired] == 'yes'
			    	@device.update(scenario: @scenario, :isReportRequired=>params[:isReportRequired])
			    	@device_report = DeviceReport.find_or_initialize_by(:device_ip=>params[:device_ip]) 
			    	@device_report.update(:device_ip=>params[:device_ip])
			    	@scenario = @device_report.device_scenarios.create(:scenario_name=>@device.scenario.scenario_name)
			    	@device.scenario.routes.each do |route|
			    		@route = @scenario.scenario_routes.create(:path=>route.path, :fixture=>route.fixture, :route_type=>route.route_type, :status=>route.status)
			    		@route.update(:path=>route.path, :fixture=>route.fixture, :route_type=>route.route_type, :status=>route.status)
			    	end
			    else
			    	@device.update(scenario: @scenario, :isReportRequired=>params[:isReportRequired])
			    end
					render :json => { :status => 'Ok', :message => 'Received'}, :status => 200 
		  end
		rescue =>e
				logger.fatal "An error has been occurred in Set_Scenario #{e.class.name} : #{e.message} \n"
				render :json => { :status => '404', :message => 'Not Found'}, :status => 404
		end
	end

    private
	def make_request_to_actual_api(method, config)
		
	   	host, path, query, body = get_request_details
	    conn = Connection.new(host, config)
	    response = ""
	    t = Thread.new{
		    case method
			    when METHOD::GET
			    	 response = conn.get(path, query, body, self.request)
			    when METHOD::POST
			     	 response = conn.post(path, query, body, self.request)
			    when METHOD::PUT
			      	 response = conn.put(path, query, body, self.request)
			    when METHOD::PATCH
			      	 response = conn.patch(path, query, body, self.request)
			    when METHOD::DELETE
			     	 response = conn.delete(path, query, body, self.request)
			end
		}
		t.join
		save_stubs(host+path<<"?"<<query, method, body, t.value[0], host, request, t.value[1].to_hash)
	    render json: t.value[0].body, :status => t.value[0].code
		
	end


	private
	def make_request_to_local_api_server(report = false)
		if report
			make_request_report
		else
			make_request
		end
	end

	private
	def make_request
		begin
			log_device_ip
			@device = Device.find_by(:device_ip=>get_ip_address)
			if @device.blank?
				log_notfound_request(get_path_query, request.method, get_ip_address)
				render :json => { :status => '404', :message => 'Not Found'}, :status => 404
			else
				@route = @device.find_route(get_path_query, request.method)
				if @route.blank?
					log_notfound_request(get_path_query, request.method, get_ip_address, @device.scenario.scenario_name)
					render :json => { :status => '404', :message => 'Not Found'}, :status => 404
				else
					render json: @route.fixture, :status => @route.status
				end
			end
		rescue =>e
			logger.fatal "An error has been occurred in respond_to_client #{e.class.name} : #{e.message} \n"
			render :json => { :status => '404', :message => 'Not Found'}, :status => 404
		end
	end

	private 
	def make_request_report
		begin
			log_device_ip
			@device = DeviceReport.find_by(:device_ip=>get_ip_address)
			@scenario = @device.device_scenarios.last
			if @device.blank?
				log_notfound_request(get_path_query, request.method, get_ip_address)
				render :json => { :status => '404', :message => 'Not Found'}, :status => 404
			else
				@route = @scenario.scenario_routes.find_by(:path=>get_path_query, :route_type=>request.method)
				if @route.blank?
					log_notfound_request(get_path_query, request.method, get_ip_address, @scenario.scenario_name)
					@scenario.scenario_routes.create(:path=>get_path_query, :route_type=>request.method, :count=>-1, :fixture=>"404")
					render :json => { :status => '404', :message => 'Not Found'}, :status => 404
				else
					if @route.fixture == "404"
					   log_notfound_request(get_path_query, request.method, get_ip_address, @scenario.scenario_name)
					   @route.update(:count=>@route.count-1)
					   render :json => { :status => '404', :message => 'Not Found'}, :status => 404
					else
						@route.update(:count=>@route.count+1)
						render json: @route.fixture, :status => @route.status
					end
				end
			end
		rescue =>e
			logger.fatal "An error has been occurred in respond_to_client #{e.class.name} : #{e.message}\n"
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
			sorted_path = sort_query_parameters("http://localhost"+path+"?"+query)
			received_path = sorted_path
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

	 private
		def save_stubs(url, method, body, response, host, request, headers)
			@route = Stub.create(:request_url=>url, :route_type=>method, :request_body=>body, :response=>response.body, :status=>response.code, :host=>host, :remote_ip=>request.remote_ip, :headers=>headers)
			 if @route.save 
				logger.fatal "Stub has been successfully saved in DB"
		     end
		end
	private 
	    def log_device_ip
             logger.fatal "Device IP:"+get_ip_address.to_s
	    end
end










