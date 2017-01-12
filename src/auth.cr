require "kemal"

class HTTP::Server::Context
	def user=(@aius_user : String)
	end
	def user
		@aius_user
	end
end

class AuthHandler < Kemal::Handler
	def call(context)
		headers = HTTP::Headers {
			"Content-Type" => "applicaton/json"
		}
		url = "https://otan.aius.u-strasbg.fr/token"

		token = context.params.json["token"]?

		if token.nil?
			puts "No token received."

			return call_next context
		end

		response = HTTP::Client.get "#{url}/#{token}", headers: headers
		response = JSON.parse response.body

		puts response

		username = response["username"]?
		scopes = response["scopes"]?

		if username.nil?
			puts "No username received during auth."

			return call_next context
		end

		username = username.as_s?

		if ! username
			puts "Invalid username received during auth."

			return call_next context
		end

		if scopes.nil?
			puts "No username received during auth."

			return call_next context
		end

		puts scopes
		if scopes.includes? "sales"
			context.user = username
		end

		call_next context
	end
end

add_handler AuthHandler.new

