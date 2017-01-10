
require "db"

class Product
	def name=(@name) end
	def category=(@category) end
	def price=(price)
		if price < 0
			raise "price cant be negative"
		end

		@price = price
	end

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

