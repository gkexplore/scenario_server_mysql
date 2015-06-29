class StubsController < ApplicationController
skip_before_filter :verify_authenticity_token
  def index
  	  @features = Feature.all
      @flows = Flow.all
      @scenarios = Scenario.all
      @stubs = Stub.all.reverse
  end
  
  def save_scenario
      begin
          begin
              feature_model = Feature.find_or_initialize_by(:feature_name=>params[:feature_name])
              feature_model.update(:feature_name=>params[:feature_name])
          rescue Exception=>e
              alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while adding the feature #{e.class.name}: #{e.message}", "/stubs", AadhiConstants::ALERT_BUTTON)
          end
          begin
               flows = feature_model.flows.find_or_initialize_by(:flow_name=>params[:flow_name])
               flows.update(:flow_name=>params[:flow_name])
          rescue Exception=>e
              alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while adding the flow #{e.class.name}: #{e.message}", "/stubs", AadhiConstants::ALERT_BUTTON)
          end
          begin
              scenarios = flows.scenarios.find_or_initialize_by(:scenario_name=>params[:scenario_name])
              scenarios.update(:scenario_name=>params[:scenario_name]) 
          rescue Exception=>e
              alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while adding the scenario #{e.class.name}: #{e.message}", "/stubs", AadhiConstants::ALERT_BUTTON)
          end
          begin
              @stubs = Stub.all.reverse
              @stubs.each do |route|
                    decoded = URI.decode(route.request_url)
                    routes = scenarios.routes.find_or_initialize_by(:path=>route.request_url)
                    routes.update(:route_type=>route.route_type,:path=>sort_query_parameters(decoded),:request_body=>route.request_body,:fixture=>route.response,:status=>route.status,:host=>route.host)
          end    
          rescue Exception=>e
              alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while adding the route #{e.class.name}: #{e.message}", "/stubs", AadhiConstants::ALERT_BUTTON)
          end 

          Stub.delete_all
          alert(AadhiConstants::ALERT_CONFIRMATION, "All the stubs have been saved successfully!!!", "/stubs", AadhiConstants::ALERT_BUTTON)
      rescue Exception=>e
         alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while storing the stubs #{e.class.name}: #{e.message}", "/stubs", AadhiConstants::ALERT_BUTTON)
       end
  end

  def poll_log
  	@stubs = Stub.all.reverse
    render layout: false
  end
 
  def clear_logs
  	begin
  		  Stub.delete_all
        alert(AadhiConstants::ALERT_CONFIRMATION, "All the stubs have been cleared successfully!!!", "/stubs", AadhiConstants::ALERT_BUTTON)
 	  rescue Exception=>e
        alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while deleting the stubs #{e.class.name}: #{e.message}", "/stubs", AadhiConstants::ALERT_BUTTON)
  	end
  end

  def destroy
    begin
        @stub = Stub.find(params[:id])
        @stub.destroy
        alert(AadhiConstants::ALERT_CONFIRMATION, "The selected stub has been deleted successfully!!!", "/stubs", AadhiConstants::ALERT_BUTTON)
    rescue=>e
        alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while deleting the stub #{e.class.name}: #{e.message}", "/stubs", AadhiConstants::ALERT_BUTTON)
    end
  end

  def server_log
    @logs = Array.new
    text=File.open('/var/www/scenario_server_mysql/log/development.log').read
    text.gsub!(/\r\n?/, "\n")
      text.each_line do |line|
        @logs.push(line)
      end
    @logs.reverse!
  end

  private
   def qs_to_hash(querystring)
      keyvals = querystring.split('&').inject({}) do |result, q| 
        k,v = q.split('=')
        if !v.nil?
           result.merge({k => v})
        elsif !result.key?(k)
          result.merge({k => true})
        else
          result
        end
      end
      keyvals
  end
  private
  def sort_query_parameters(url)
      temp_url = URI.parse(url)
      query = temp_url.query
      if query==nil || query=='' || query.blank?
        path = temp_url.path
      else
        puts "query ***"+query
        path = temp_url.path
      hash_string = qs_to_hash(query)
      sorted_string =  Hash[hash_string.sort]
      final_sorted_string = sorted_string.to_query
      if final_sorted_string.to_s.strip.length != 0
        final_sorted_string = "?"<<final_sorted_string
      end
      path+final_sorted_string
    end
  end

end
