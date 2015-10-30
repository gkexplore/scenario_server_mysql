class ScenariosController < ApplicationController

	skip_before_action :verify_authenticity_token

	def index

	end

	def create
		begin
			@feature = Feature.find(params[:feature_id])
	    	@flow = @feature.flows.find(params[:flow_id])
	    	@scenario = @flow.scenarios.create(scenario_params)
	    	flash.now[:success] = "The scenario has been created successfully !!!"
	    	render 'flows/show'
	    rescue=>e	
	    	flash.now[:error] = "An error has been occurred while creating the scenario #{e.class.name}: #{e.message}"
			render 'flows/show'
		end
	end

	def new

	end

	def edit
		begin
			@feature = Feature.find(params[:feature_id])
			@flow = @feature.flows.find(params[:flow_id])
			@scenario = @flow.scenarios.find(params[:id])
		rescue=>e
			flash.now[:error] = "An error has been occurred while retrieving the scenario #{e.class.name}: #{e.message}"	
			render 'flows/show'
		end
	end

	def show
		begin
			@redirect_path = request.path
			@scenarios = Scenario.all
			@feature = Feature.find(params[:feature_id])
			@flow = @feature.flows.find(params[:flow_id])
			@scenario = @flow.scenarios.find(params[:id])
		rescue=>e	
			flash.now[:error] = "An error has been occurred while retrieving the scenario #{e.class.name}: #{e.message}"	
			render 'flows/show'
		end
	end

	def update
		begin
			@feature = Feature.find(params[:feature_id])
			@flow = @feature.flows.find(params[:flow_id])
			@scenario = @flow.scenarios.find(params[:id])
			if @scenario.update(scenario_params)
			   flash.now[:success] = "The scenario has been updated successfully !!!"
			   render 'flows/show'
			end
		rescue=>e
			flash.now[:error] = "An error has been occurred while updating the scenario #{e.class.name}: #{e.message}"
			render 'scenarios/edit'
		end
	end

	def destroy
		begin
			@feature = Feature.find(params[:feature_id])
			@flow = @feature.flows.find(params[:flow_id])
			@scenario = @flow.scenarios.find(params[:id])
			@scenario.destroy
			flash.now[:success] = "The scenario has been deleted successfully !!!"
			render 'flows/show'
		rescue=>e
			flash.now[:error] = "An error has been occurred while deleting the scenario #{e.class.name}: #{e.message}"
			render 'flows/show'
		end
	end

	def debug
		begin
			remote_ip=request.remote_ip
			if remote_ip=="::1"
				@request_ip="127.0.0.1"
			else
				@request_ip=remote_ip
			end	
			@scenarios=Scenario.all
			@devices = Device.all
		rescue =>e
			flash[:danger] = "An error has been occurred while retrieving the device and scenario details"
		end
	end

	def device_list
		begin
			@devices = Device.all
			render layout: false
		rescue=>e
			flash[:danger] = "An error has been occurred while retrieving the device and scenario details"
		end
	end
    
    def clear_device_list
    	begin
    		Device.delete_all
    		flash[:success] = "All the devices have been cleared successfully!!!"
    		redirect_to '/scenarios/debug'
 	  rescue Exception=>e
       		flash[:danger] = "An error has been occurred while deleting the device list #{e.class.name}: #{e.message}"
       		redirect_to '/scenarios/debug'
  		end
    end

	def set_current_scenario
		begin
		   @scenario = Scenario.find_by(:scenario_name=>params[:scenario_name])
		   if @scenario.blank?
			    flash[:danger] = "An error has been occurred while setting #{params[:scenario_name]} scenario. Please set a valid scenario"
			    redirect_to '/scenarios/debug'
			else
				@device = Device.find_or_initialize_by(:device_ip=>params[:device_ip])
		  		@device.update(scenario: @scenario)
		  		flash[:success] = "The selected scenario has been set successfully!!!"
			    redirect_to '/scenarios/debug'
		    end
		rescue =>e
				flash[:danger] = "An error has been occurred while setting the scenario"
				redirect_to '/scenarios/debug' 
		end	
	end

    def copy_or_find_route
    	begin 
    		@redirect_path = params[:redirect_path]
    		if params[:commit] == "Copy to scenario"
    			@action = "Copy"
		    	@routes = Route.find(params[:route_ids])
		    	@features = Feature.all
		    	@flows = Flow.all
		    	@scenarios = Scenario.all
		    elsif params[:commit] == "Find in scenario"
		    	scenario_ids = Array.new
		    	@route_ids = Array.new
		    	@action = "Find"
		    	@routes = Route.find(params[:route_ids])
		    	@routes.each do |route|
		    		@route_ids.push(route.id)
		    		identified_routes = Route.where(:path=>route.path, :fixture=>route.fixture)
		    		  identified_routes.each do |ir|
		    			scenario_ids.push(ir.scenario_id)
		    		  end
		    	end
		    	@scenario = @routes[0].scenario
		    	@scenarios = Scenario.find(scenario_ids)
		    	@scenarios_identified_for_replace = Scenario.where(:isTemp=>"yes")
		    end 
		rescue =>e
			flash[:danger] = "An error has been occurred while retrieving the scenario!!!"
		end   		
    end

    def save_route
    	begin 
    		@routes = Route.find(params[:route_ids])
    		Route.save_routes(params[:feature_name], params[:flow_name], params[:scenario_name], @routes)
    		flash[:success] = "The selected urls have been copied to #{params[:feature_name]}->#{params[:flow_name]}->#{params[:scenario_name]}!!!"
    		redirect_to :back
    	rescue =>e
	    	flash[:danger] = "An error has been occurred while copying the scenario!!!"
	    	redirect_to :back
	    end
    end

    def insert_or_update_routes
        begin
        	if params[:commit] == "Replace"
		    	@routes = Route.find(params[:route_ids])
		    	@scenarios = Scenario.find(params[:scenario_ids])
		    	Route.save_routes_to_scenario(@routes, @scenarios)
		    	@scenarios_identified_for_replace = Scenario.where(:isTemp=>"yes")
		    	@scenarios_identified_for_replace.each do |scenario|
		    		scenario.update(:isTemp=>"no")
		    	end
		    	flash[:success] = "The selected urls have been copied/replaced in selected scenarios!!!"
		        redirect_to :back
		    elsif params[:commit] == "Save to Replace"
		    	@routes = Route.find(params[:route_ids])
		    	@scenarios = Scenario.find(params[:scenario_ids])
		    	Route.save_to_replace(@scenarios)
		    	flash[:success] = "The selected urls have been marked to replace.!!!"
		        redirect_to :back
		    end
		rescue =>e
	    	flash[:danger] = "An error has been occurred while copying the scenario!!!"
	    	redirect_to :back
	    end

    end

    def revert_marked_scenarios
    	begin
	    	@scenarios_identified_for_replace = Scenario.where(:isTemp=>"yes")
	    	@scenarios_identified_for_replace.each do |scenario|
	    		scenario.update(:isTemp=>"no")
	    	end
	    	flash[:success] = "All the marked scenarios have been reverted successfully!!!"
		    redirect_to :back
	    rescue=>e
	    	flash[:danger] = "An error has been occurred while reverting marked scenario!!!"
	    	redirect_to :back
	    end
    end

	private
	 def scenario_params
		params.require(:scenario).permit(:scenario_name)
	 end
end
