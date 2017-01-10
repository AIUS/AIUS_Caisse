
require "db"

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

