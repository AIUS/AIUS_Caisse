require "kemal"

require "db"
require "pg"

require "../error"

require "../categories"

get "/categories" do |context|
	context.response.content_type = "application/json"
	Category.from_rs(context.db.query "SELECT id, name FROM product_category").to_json
end

get "/category/:id" do |context|
	context.response.content_type = "application/json"
	this_id = context.params.url["id"]
	puts this_id
	this_category = context.db.query_one "SELECT id, name FROM product_category WHERE id = $1", this_id, as: Category
	if this_category.nil?
		error "category not found"
	else
		this_category.to_json
	end
end

post "/categories" do |context|
	name = context.params.json["name"]?.as?(String)

	if name.nil?
		error "missing `name` field"
	else
		new_id = context.db.scalar "INSERT INTO product_category (name) VALUES ($1) RETURNING id", name
		(context.db.query_one "SELECT id, name FROM product_category WHERE id = $1", new_id, as: Category).to_json
	end
end

delete "/category/:id" do |context|
	id = context.params.url["id"]
	context.db.exec "DELETE FROM product_category WHERE id = $1", id
end

put "/category/:id" do |context|
	id = context.params.url["id"]
	category = context.db.query_one "SELECT id, name FROM product_category WHERE id = $1", id, as: Category
	if category.nil?
		error "category not found"
	else
		name = context.params.json["name"]?.as?(String)
		if !name.nil?
			category.name = name
		end

		context.db.exec "UPDATE product_category SET (name) = ($2) WHERE id = $1", category.id, category.name
		category.to_json
	end
end
