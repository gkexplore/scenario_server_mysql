class StubsController < ApplicationController
  def index
  	
  end

  def poll_log
  	@stubs = Stub.all.reverse
  end
end
