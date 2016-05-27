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
          Stub.save_stubs(params[:feature_name], params[:flow_name], params[:scenario_name])
          Stub.delete_all
          flash[:success] = "All the stubs have been saved successfully!!!"
          redirect_to '/stubs'
      rescue Exception=>e
          flash[:danger] = "An error has been occurred while storing the stubs #{e.class.name}: #{e.message}"
          redirect_to '/stubs'
       end
  end

  def poll_log
      @duplicate_id_list = Array.new
  	  @stubs = Stub.all.reverse
      @duplicate_calls = Stub.select(:id).group(:request_url,:route_type,:response).having("count(*) > 1")
      @duplicate_calls.each do |request|
        @duplicate_id_list.push(request.id)
      end
      render layout: false
  end
 
  def clear_logs
  	begin
  		  Stub.delete_all
        flash[:success] = "All the stubs have been cleared successfully!!!"
        redirect_to '/stubs'
 	  rescue Exception=>e
        flash[:danger] = "An error has been occurred while deleting the stubs #{e.class.name}: #{e.message}"
        redirect_to '/stubs'
  	end
  end

  def destroy
    begin
        @stub = Stub.find(params[:id])
        @stub.destroy
        flash[:success] = "The selected stub has been deleted successfully!!!"
        redirect_to '/stubs'
    rescue=>e
        flash[:success] = "An error has been occurred while deleting the stub #{e.class.name}: #{e.message}"
        redirect_to '/stubs'
    end
  end

  def server_log
     
  end

  def poll_server_log
      log = File.join(Rails.root, "log", "#{ Rails.env }.log")
      @lines = `tail -1024 #{ log }`.split(/\n/).reverse
      render layout: false
  end

  def clear_server_log  
    begin
       log = File.join(Rails.root, "log", "#{ Rails.env }.log")
        File.truncate(log, 0)
        flash[:success] = "The server log has been emptied successfully!!!"
        redirect_to '/stubs/server_log'
      rescue=>e
        flash[:danger] = "An error has been occurred while deleting the server log #{e.class.name}: #{e.message}"
        redirect_to '/stubs/server_log'
      end
    end

end
