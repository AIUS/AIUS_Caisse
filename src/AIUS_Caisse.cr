require "kemal"

require "db"
require "pg"

class HTTP::Server::Context
	def db=(@db : DB::Database)
	end
	def db
		@db
	end
end

class CustomHandler < Kemal::Handler
	def call(context)
		DB.open "postgres:///aius_caisse" do |db|
			context.db = db

			call_next context
		end
	end
end

add_handler CustomHandler.new

get "/" do |context|
	context.db.to_s
end

Kemal.run
