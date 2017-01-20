require "../sale"

get "/sale/" do |context|	
	begin
		dbegin = context.params.query["begin"]?.as?(String)
		if dbegin.nil?
			dbegin = Time.parse("1995-04-24","%Y-%m-%d")
		else
			dbegin = Time.parse(dbegin,"%Y-%m-%d")
		end
		dend = context.params.query["end"]?.as?(String)
		if dend.nil?
			dend = Time.now()
		else
			dend = Time.parse(dend,"%Y-%m-%d")
		end
	rescue
		next error "Syntax Date incorect"
	end

	sales = Sale.from_rs(context.db.query "SELECT id,seller,date FROM sale WHERE $1::date < date and date <= $2::date ",dbegin,dend)
	sales.map do |sale|
		sale.searchProduct(context.db)
	end
	sales.to_json
end 

post "/sale/" do |context|
	sale_products = context.params.json["data"]?.as?(Array(JSON::Type))
	if context.user.nil?
		error "unauthorized user"
	elsif sale_products.nil?
		error "Incorrect JSON"	
	else
		ids = [] of Int64
		stack = nil
		i = 0
		while i < sale_products.size
			sale_product = sale_products[i].as?(Hash(String,JSON::Type))
			i += 1
			if sale_product.nil?
				stack = error "Incorrect JSON 2"
				break
			else
				id = sale_product["id"]?.as?(Int64)
				qt = sale_product["quantity"]?.as?(Int64)	
				if id.nil? || qt.nil?
					stack = error "Incorrect JSON 3"
					break
				elsif qt < 1
					stack = error "Incorrect quantity"
					break
				elsif ids.includes?(id)
					stack = error "Incorrect product"
					break
				elsif (context.db.query_one? "SELECT id FROM product WHERE id = $1",id, as: Int32).nil?
					stack = error "Product not found"
					break
				else
					ids.insert(-1,id)
				end
			end
		end
		if !stack.nil?
			next stack
		end
		sale = context.db.scalar "INSERT INTO sale (seller) VALUES ('110e8400-e29b-11d4-a716-446655440000') RETURNING id"
		i = 0
		while i < sale_products.size
			sale_product = sale_products[i].as?(Hash(String,JSON::Type))
			i += 1
			if !sale_product.nil?
				id = sale_product["id"]?.as?(Int64)
				qt = sale_product["quantity"]?.as?(Int64)
				if !id.nil? && !qt.nil?
					context.db.exec "INSERT INTO sale_product (sale,product,quantity) VALUES ($1,$2,$3)" , sale,id,qt
				end
			end
		end

	 	(context.db.query_one? "SELECT id,seller,date FROM sale WHERE id = $1",sale,as: Sale).to_json
	end
end

delete "/sale/:id" do |context|
	id = context.params.url["id"]
	context.db.exec "DELETE FROM sale_product WHERE sale=$1",id
	if (context.db.exec "DELETE FROM sale WHERE id=$1",id).rows_affected > 0
		{	"status" => "OK"}.to_json
	else
		error "No row affected."
	end
end


