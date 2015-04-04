
module FeaturesHelper
	def store_json(file)
		directory ="public"
		path = File.join(directory,file['datafile'].original_filename)
		File.open(path,"wb"){|f| f.write(file['datafile'].read)}
		xdoc = Nokogiri::XML(File.read("#{directory}/#{file['datafile'].original_filename}"))
			( xdoc/'/features/feature' ).each {|feature|

				feature_model = Feature.find_or_initialize_by(:id=>(feature/'./id').text,:feature_name=>(feature/'./feature-name').text)
				feature_model.update(:id=>(feature/'./id').text,:feature_name=>(feature/'./feature-name').text)

			  (feature/'flows/flow').each {|flow|
			  	flows = feature_model.flows.find_or_initialize_by(:id=>(flow/'./id').text,:feature_id=>(flow/'./feature-id').text,:flow_name=>(flow/'./flow-name').text)
				flows.update(:flow_name=>(flow/'./flow-name').text)


			    (flow/'scenarios/scenario').each {|scenario|
			    	scenarios = flows.scenarios.find_or_initialize_by(:id=>(scenario/'./id').text,:flow_id=>(scenario/'./flow-id').text,:scenario_name=>(scenario/'./scenario-name').text)
					scenarios.update(:scenario_name=>(scenario/'./scenario-name').text)
	
			    	(scenario/'routes/route').each {|route|
			    		routes = scenarios.routes.find_or_initialize_by(:path=>(route/'./path').text)
						routes.update(:scenario_id=>(route/'./scenario-id').text,:route_type=>(route/'./route-type').text,:path=>(route/'./path').text,:request_body=>(route/'./request-body').text,:fixture=>(route/'./fixture').text,:status=>(route/'./status').text,:host=>(route/'./host').text)
						
					
					}
			    }
			  }
			}
		end
end
