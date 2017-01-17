require "kemal"

class JSONHandler < Kemal::Handler
	def call(context)
		context.response.content_type = "application/json"

		call_next context
	end
end

add_handler JSONHandler.new


