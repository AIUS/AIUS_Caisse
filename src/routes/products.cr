require "kemal"

require "db"
require "pg"

require "../error"

require "../product"

get "/products" do |context|
	Product.from_rs(context.db.query "SELECT id, name, category, price FROM product").to_json
end

get "/product/:id" do |context|
	id = context.params.url["id"]
	product = context.db.query_one? "SELECT id, name, category, price FROM product WHERE id = $1", id, as: Product

	if product.nil?
		error "product not found"
	else
		product.to_json	
	end
end

post "/products" do |context|
	name = context.params.json["name"]?.as?(String)
	p = context.params.json["price"]?
	category = context.params.json["category"]?
	price = p.as?(Int64) || p.as?(Float64)

	if context.user.nil?
		error "unauthorized user"
	elsif name.nil?
		error "missing `name` field"
	elsif p.nil?
		error "missing `price` field"
	elsif price.nil?
		error "`price` has to be a number"
	elsif price < 0
		error "`price` can't be < 0"
	else
		new_id = context.db.scalar "INSERT INTO product (name, category, price) VALUES ($1, $2, $3) RETURNING id", name, category, price
		(context.db.query_one? "SELECT id, name, category, price FROM product WHERE id = $1", new_id, as: Product).to_json
	end
end

delete "/product/:id" do |context|
	if context.user.nil?
		error "unauthorized user"
	else
		id = context.params.url["id"]
		result = context.db.exec "DELETE FROM product WHERE id = $1", id

		if result.rows_affected == 0
			error "product not found"
		else
			{
				"status" => "ok"
			}.to_json
		end
	end
end

put "/product/:id" do |context|
	id = context.params.url["id"]
	product = context.db.query_one? "SELECT id, name, category, price FROM product WHERE id = $1", id, as: Product
	if context.user.nil?
		error "unauthorized user"
	elsif product.nil?
		error "product not found"
	else
		name = context.params.json["name"]?.as?(String)
		if !name.nil?
			product.name = name
			puts product.name
		end
		category = context.params.json["category"]?.as?(Int32)
		if !category.nil?
			product.category = category
		end
		p = context.params.json["price"]?
		price = p.as?(Int64) || p.as?(Float64)
		if !price.nil?
			product.price = price.to_f64
		end

		result = context.db.exec "UPDATE product SET (name, category, price) = ($2, $3, $4) WHERE id = $1", product.id, product.name, product.category, product.price
		if result.rows_affected == 0
			error "product not found"
		else
			product.to_json
		end
	end
end

