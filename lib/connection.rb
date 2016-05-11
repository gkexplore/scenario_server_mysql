
class Connection

	include DevicesHelper	

	def initialize(endpoint, config)
		  @endpoint = endpoint
		  @proxy_uri = URI.parse(config[0].url)
		  @proxy = config
	end

	def get(path, params, body, request)
	  return make_request :get, path, params, body, request
	end

	def post(path, params, body, request)
		  return make_request :post, path, params, body, request
	end

	def put(path, params, body, request)
	  return make_request :put, path, params, body, request
	end

	def patch(path, params, body, request)
	  return make_request :patch, path, params, body, request
	end

	def delete(path, params, body, request)
	  return make_request :delete, path, params, body, request
	end

	private
	  def make_request(method, path, params, body, request)
	  	  uri = URI(@endpoint+path<<"?"<<params)
	  case method
	    when :get
		       req = Net::HTTP::Get.new uri
				   req = form_request_headers(request, req)
	    when :post
		       req = Net::HTTP::Post.new uri
		       req.body = body
		       req = form_request_headers(request, req)
	    when :put
		       req = Net::HTTP::Put.new uri
		       req.body = body
		       req = form_request_headers(request, req)
		when :patch
		       req = Net::HTTP::Patch.new uri
		       req.body = body
		       req = form_request_headers(request, req)
	    when :delete
		       req = Net::HTTP::Delete.new uri
		       req.body = body
		       req = form_request_headers(request, req)
	  end

	  case @proxy[0].isProxyRequired 
		when PROXY::NO
			Rails.logger.fatal "Request:"+@endpoint+path<<"?"<<params+"\n"
			Net::HTTP.start(uri.host, uri.port, :use_ssl =>(uri.scheme == "https"), :verify_mode =>OpenSSL::SSL::VERIFY_NONE, :read_timeout => 10) do |http|
				 	response = http.request(req)
				 	Rails.logger.fatal "Response: STATUS:"+response.code+"  "+@endpoint+path<<"?"<<params+"\n"
				 #	save_stubs(@endpoint+path<<"?"<<params, method, body, response, @endpoint, request, req.to_hash)
				 	return [response, req.to_hash]	
			 end
			when PROXY::YES
				 Rails.logger.fatal "Request:"+@endpoint+path<<"?"<<params+"\n"
				 bypass_proxy_domains = @proxy[0].bypass_proxy_domains
				 if bypass_proxy_domains.include?(@endpoint)  
	   			 	Net::HTTP.start(uri.host, uri.port, :use_ssl =>(uri.scheme == "https"), :verify_mode =>OpenSSL::SSL::VERIFY_NONE, :read_timeout => 10) do |http|
		  			 	response = http.request(req)
		  			 	Rails.logger.fatal "Response: STATUS:"+response.code+"  "+@endpoint+path<<"?"<<params+"\n"
		  			 	#save_stubs(@endpoint+path<<"?"<<params, method, body, response, @endpoint, request, req.to_hash)
		  			 	return [response, req.to_hash]
				   end
				 else
	   			 Net::HTTP::Proxy(@proxy_uri.host, @proxy_uri.port, @proxy[0].user, @proxy[0].password).start(uri.host, uri.port, :use_ssl =>(uri.scheme == "https"), :verify_mode =>OpenSSL::SSL::VERIFY_NONE, :read_timeout => 10)  do |http|
			   		response = http.request(req)
			   		Rails.logger.fatal "Response: STATUS:"+response.code+"  "+@endpoint+path<<"?"<<params+"\n"
			   		#save_stubs(@endpoint+path<<"?"<<params, method, body, response, @endpoint, request, req.to_hash)
					return [response, req.to_hash]
	  			end
	  		end
	  end
	end

	private 
	def form_request_headers(request, req)
		request.env.each do |header|
	        final_key = header[0].downcase
	         	if (final_key.include?("http_") && !final_key.include?("http_host") && !final_key.include?("http_cookie"))
	            	final_key.slice!'http_'
	          		if final_key.include?("user_agent")
	            		req.add_field("User-Agent", header[1])
	           		else
	           			req.add_field(final_key, header[1])
	            	end
	            elsif(final_key.include?("content-type") || final_key.include?("content_type"))
	            	req.content_type="#{header[1]}"
	         	end
	    end
	    return req
	end

end