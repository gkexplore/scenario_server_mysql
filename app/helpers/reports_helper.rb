
module ReportsHelper

    def upload_report_xml(file)

      directory ="public"
      path = File.join(directory,file['datafile'].original_filename)
      File.open(path,"wb"){|f| f.write(file['datafile'].read)}
      xdoc = Nokogiri::XML(File.read("#{directory}/#{file['datafile'].original_filename}"))

      ( xdoc/'/device-reports/device-report' ).each {|report|

        device = DeviceReport.where(:device_ip=>(report/'./device-ip').text)

        unless device.blank?
          device[0].destroy
        end

        device_report_model= DeviceReport.create(:device_ip=>(report/'./device-ip').text)

        (report/'device-scenarios/device-scenario').each {|scenario|
          scenario_model =  device_report_model.device_scenarios.create(:scenario_name=>(scenario/'./scenario-name').text)
            (scenario/'scenario-routes/scenario-route').each {|route|
               scenario_model.scenario_routes.create(:count=>(route/'./count').text,:route_type=>(route/'./route-type').text,:path=>(route/'./path').text,:fixture=>(route/'./fixture').text,:status=>(route/'./status').text)
            }
          }
        }

    end

end