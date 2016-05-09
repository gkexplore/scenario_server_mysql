module DevicesHelper

	DEFAULT_LOCALHOST="::1"
	LOCALHOST="127.0.0.1"
	
	module SERVER_MODE
		DEFAULT = 'default'
		REFRESH = 'refresh'
		RECORD = 'record'
	end

	module PROXY
		YES = 'yes'
		NO = 'no'
	end

	module METHOD
		GET = 'GET'
		POST = 'POST'
		PUT = 'PUT'
		PATCH = 'PATCH'
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

end

