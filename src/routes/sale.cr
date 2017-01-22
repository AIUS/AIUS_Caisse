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
		next error "Incorrect syntax Date."
	end

	sales = Sale.from_rs(context.db.query "SELECT id,seller,date FROM sale WHERE $1::date < date and date <= $2::date ",dbegin,dend)
	sales.map do |sale|
		sale.searchProduct(context.db)
	end
	sales.to_json
end 

post "/sale/" do |context|
	saleProducts = context.params.json["data"]?.as?(Array(JSON::Type))
	if context.user.nil?
		error "Unauthorized user."
	elsif saleProducts.nil?
		error "Incorrect Array of products."	
	else
		begin
			sale = Sale.new("110e8400-e29b-11d4-a716-446655440000")#FIXME uuid de l'user
			sale<< saleProducts
			sale.save(context.db)
		rescue er
			next error er.message
		end
		{	"status" => "OK"}.to_json
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

