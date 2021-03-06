require "kemal"

require "db"
require "pg"

class HTTP::Server::Context
	def db=(@db : DB::Database)
	end
	def db
		@db.as DB::Database
	end
end

class DBHandler < Kemal::Handler
	def call(context)
		DB.open "postgres:///aius_caisse" do |db|
			context.db = db

			call_next context
		end
	end
end

add_handler DBHandler.new


