module AlertHelper
	def alert(message_type, message, navigation_url, button)
		@message_type = message_type
        @message = message
        @navigation_url = navigation_url
        @button = button
        render :file => "/common/alert"
	end
end