require "db"

class Sale
	@id = 0
	@seller = ""
	@saleProducts = [] of SaleProduct
	@date = Time.now
	def initialize(s)
		self.seller=s
	end
	def	seller=(@seller) end#FIXME test uuid
	def id=(@id)end
	def id 
		@id 
	end

	def <<(pd)
		if @saleProducts.any? { |saleProduct| saleProduct.product = pd.product}
			raise "Already id of product."
		end
			@saleProducts << pd
	end

	def <<(pds : Array(SaleProduct))
		pds.each {|pd| self<< pd}
	end

	def <<(pds : Array(JSON::Type))
		pds.each { |pd|	self<< SaleProduct.new(pd)}
	end
	
	def searchProduct(db)
		self<< (SaleProduct.from_rs(db.query "SELECT sale, product, quantity FROM sale_product WHERE sale = $1",@id))
	end

	def save(db)
		@saleProducts.each do |pd| 
			if pd.isNotInDB(db)
				raise "Product not found."
			end
		end
		id = (db.scalar "INSERT INTO sale (seller) VALUES ($1) RETURNING id", @seller).as?(Int32)
		if !id.nil?
			@id=id
			@saleProducts.each do |pd|
				pd.sale= @id
				pd.save(db)
			end
		end
	end

	DB.mapping({
		id: Int32,
		seller: String,
		date: Time
	})

	JSON.mapping({
		id: Int32,
		seller: String,
		saleProducts: Array(SaleProduct),
		date: Time
	})
end

class SaleProduct
	@sale = 0
	@product = 0
	@quantity = 0
	def initialize(pd : JSON::Type)
		pd = pd.as?(Hash(String,JSON::Type))
		if pd.nil?
			raise "Not a JSON valid."
		else
			id = pd.["id"]?.as?(Int64)
			qt = pd.["quantity"]?.as?(Int64)
			if id.nil?
				raise "No id of product."
			elsif qt.nil?
				raise "No quantity of product."
			else
				self.product=id.to_i
				self.quantity=qt.to_i
			end
		end
	end

	def sale=(@sale) end
	def product=(@product) end
	def quantity=(qt)
		if qt > 0
			raise "Quantity can't be negative."
		end
		@quantity=qt
	end

	def isNotInDB(db)
		(db.query_one? "SELECT id FROM product WHERE id = $1", @product, as: Int32).nil?
	end

	def save(db)
		db.exec "INSERT INTO sale_product (sale, product, quantity) VALUES ($1,$2,$3)", @sale,@product,@quantity
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
