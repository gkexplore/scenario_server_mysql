class StubsController < ApplicationController

  def index
  	
  end
  
  def poll_log
  	@stubs = Stub.all.reverse
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
        alert(AadhiConstants::ALERT_CONFIRMATION, "The selected stub has been deleted successfully!!!", "/stubs", AadhiConstants::ALERT_BUTTON)
    rescue=>e
        alert(AadhiConstants::ALERT_ERROR, "An error has been occurred while deleting the stub #{e.class.name}: #{e.message}", "/stubs", AadhiConstants::ALERT_BUTTON)
    end
  end

end
