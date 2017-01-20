
require "db"

class Sale
	@sale_products = [] of Sale_product
	def	seller=(@seller) end#FIXME test uuid
	
	def <<(pd)
		if @sale_products.any? { |sale_product| sale_product.product = pd.product}
				raise "Already id of product"
		end
			@sale_products << pd
	end

	def <<(pd : Array(Sale_product))
		i = 0
		while i < pd.size
			self<< pd[i]
			i =+ 1
		end
	end

	def searchProduct(db)
		self<< (Sale_product.from_rs(db.query "SELECT sale, product, quantity FROM sale_product WHERE sale = $1",@id))
	end

	DB.mapping({
		id: Int32,
		seller: String,
		date: Time
	})

	JSON.mapping({
		id: Int32,
		seller: String,
		sale_products: Array(Sale_product),
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
		sale: Int32,
		product: Int32,
		quantity: Int32
	})

	JSON.mapping({
		sale: Int32,
		product: Int32,
		quantity: Int32	
	})
end
