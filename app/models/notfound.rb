class Notfound < ActiveRecord::Base
    
    after_update :flush_not_found_hash
	
	def self.find_notfound_requests(device_ip)
		Rails.cache.fetch([:notfound, device_ip]) do
			where(:device_ip=>device_ip) 
        end
	end

	def flush_not_found_hash
		Rails.cache.delete([:notfound, device_ip])
 	end

end
