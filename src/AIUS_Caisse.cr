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

class Product
	DB.mapping({
		id: Int32,
		name: String,
		category: Int32,
		price: Float64,
	})

	JSON.mapping({
		id: Int32,
		name: String,
		category: Int32,
		price: Float64,
	})
end

get "/products" do |context|
	Product.from_rs(context.db.query "SELECT id, name, category, price FROM product").to_json
end

class Category
	DB.mapping({
		id: Int32,
		name: String
	})

	JSON.mapping({
		id: Int32,
		name: String
	})
end

get "/categories" do |context|
	Category.from_rs(context.db.query "SELECT id, name FROM product_category").to_json
end

Kemal.run
