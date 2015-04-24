module DevicesHelper
	module SERVER_MODE
		DEFAULT = 'default'
		REFRESH = 'refresh'
		RECORD = 'record'
	end

	module METHOD
		GET = 'GET'
		POST = 'POST'
		PUT = 'PUT'
		DELETE = 'DELETE'
	end

	module SCHEME
		HTTP = "http"
		HTTPS = "https"
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

	def form_request_headers_and_hit_api(req,path,query,body)
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


	def make_request_to_actual_api(method)
		 puts "** host: " + request.host
		 puts "** path: " + request.path

		 host_path = request.host + request.path
		 body = request.body.read
		 query = request.query_string
		 path = get_path(host_path)
		 path_array = host_path.split("/")
		 case request.env["rack.url_scheme"]
		 when SCHEME::HTTP
			 host = SCHEME::HTTP<<"://"<<path_array[1]
		 when SCHEME::HTTPS
			 host = SCHEME::HTTPS<<"://"<<path_array[1]
		 end

	    conn = get_connection(host)
	    puts host<<path<<"?"<<query 
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
	   
	    render json: response.body, :status => response.status
	end

	def make_request_to_local_api_server
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
