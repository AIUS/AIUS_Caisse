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
		category: {
			type: Int32,
			nilable: true,
		},
		price: Float64,
	})

	JSON.mapping({
		id: Int32,
		name: String,
		category: Int32 | Nil,
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

def error(message)
	{
		"status" => "error",
		"message" => message,
	}.to_json
end

post "/products" do |context|
	name = context.params.json["name"]?.as?(String)
	p = context.params.json["price"]?
	price = p.as?(Int64) || p.as?(Float64)

	if name.nil?
		error "missing `name` field"
	elsif p.nil?
		error "missing `price` field"
	elsif price.nil?
		error "`price` has to be a number"
	elsif price < 0
		error "`price` can't be < 0"
	else
		new_id = context.db.scalar "INSERT INTO product (name, price) VALUES ($1, $2) RETURNING id", name, price
		(context.db.query_one "SELECT id, name, category, price FROM product WHERE id = $1", new_id, as: Product).to_json
	end
end

delete "/product/:id" do |context|
	id = context.params.url["id"]
	context.db.exec "DELETE FROM product WHERE id = $1", id
end

Kemal.run


