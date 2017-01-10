require "kemal"

require "db"
require "pg"

require "../error"

require "../categories"

get "/categories" do |context|
	Category.from_rs(context.db.query "SELECT id, name FROM product_category").to_json
end

