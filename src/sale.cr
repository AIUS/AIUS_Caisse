
require "db"

class Sale
	@sale_products = [] of Sale_product
	def	seller=(@seller) end#FIXME test uuid
	
	def <<(pd)
		if @sale_products.any? { |sale_product| sale_product.id = pd.id}
			raise "Already id of product"
		end
			@sale_products << pd
	end

	DB.mapping({
		id: Int32,
		seller: String,
		date: Time
	})

	JSON.mapping({
		id: Int32,
		seller: String,
		date: Time
	})
end

class Sale_product
	def sale=(@sale) end
	def product=(@sale) end
	def quantity=(qt)
		if qt > 0
			raise "Quantity can't be negative"
		end
		@quantity=qt
	end

	DB.mapping({
		id: Int32,
		sale: Int32,
		product: Int32,
		quantity: Int32
	})

	JSON.mapping({
		id: Int32,
		sale: Int32,
		product: Int32,
		quantity: Int32	
	})
end
