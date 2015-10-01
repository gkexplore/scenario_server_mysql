
module AadhiModelUtil

	def qs_to_hash(querystring)
		  keyvals = querystring.split('&').inject({}) do |result, q| 
		    k,v = q.split('=')
		    if !v.nil?
		       result.merge({k => v})
		    elsif !result.key?(k)
		      result.merge({k => ''})
		    else
		      result
		    end
		  end
		  keyvals
	end

	def sort_query_parameters(url)
    	temp_url = URI.parse(url)
    	query = temp_url.query
    	if query==nil || query=='' || query.blank?
    		path = temp_url.path
    	else
	    	path = temp_url.path
			hash_string = qs_to_hash(query)
			sorted_string =  Hash[hash_string.sort]
			final_sorted_string = sorted_string.to_query
			if final_sorted_string.to_s.strip.length != 0
				final_sorted_string = "?"<<final_sorted_string
			end
			path+URI.unescape(final_sorted_string)
		end
	end

end

ActiveRecord::Base.extend AadhiModelUtil