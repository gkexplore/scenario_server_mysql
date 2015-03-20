class ScenariosController < ApplicationController
	
	def index
		@current_scenario = Rails.application.config.scenario
		puts "Current Scenario:"<<@current_scenario
	end	

	def new

	end

	def create

	end

	def edit

	end

	def show

	end

	def update

	end

	def destroy

	end

end
