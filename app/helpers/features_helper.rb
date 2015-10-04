
module FeaturesHelper
	def store_xml(file)
		directory ="public"
		path = File.join(directory,file['datafile'].original_filename)
		File.open(path,"wb"){|f| f.write(file['datafile'].read)}
		xdoc = Nokogiri::XML(File.read("#{directory}/#{file['datafile'].original_filename}"))
			( xdoc/'/features/feature' ).each {|feature|

				feature_model = Feature.find_or_initialize_by(:feature_name=>(feature/'./feature-name').text)
				feature_model.update(:feature_name=>(feature/'./feature-name').text)

			  (feature/'flows/flow').each {|flow|
			  	flows = feature_model.flows.find_or_initialize_by(:flow_name=>(flow/'./flow-name').text)
				flows.update(:flow_name=>(flow/'./flow-name').text)


			    (flow/'scenarios/scenario').each {|scenario|
			    	scenarios = flows.scenarios.find_or_initialize_by(:scenario_name=>(scenario/'./scenario-name').text)
					scenarios.update(:scenario_name=>(scenario/'./scenario-name').text)
	
			    	(scenario/'routes/route').each {|route|
			    		routes = scenarios.routes.find_or_initialize_by(:path=>(route/'./path').text, :route_type=>(route/'./route-type').text)
						routes.update(:route_type=>(route/'./route-type').text,:path=>(route/'./path').text,:request_body=>(route/'./request-body').text,:fixture=>(route/'./fixture').text,:status=>(route/'./status').text,:host=>(route/'./host').text)
						
					
					}
			    }
			  }
			}
		end
end
