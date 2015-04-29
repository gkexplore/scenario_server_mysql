class StubsController < ApplicationController
  def index
  	@stubs = Stub.all
  end
end
