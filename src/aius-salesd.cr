
require "kemal"

require "./db"
require "./auth"

get "/" do |context|
	context.db.to_s
end

require "./routes/products"
require "./routes/categories"
require "./routes/sale"

class Kemal::Config
	@aius_otan = "https://otan.aius.u-strasbg.fr"
	@aius_scope = "sales"

	def aius_otan=(@aius_otan) end
	def aius_otan
		@aius_otan
	end

	def aius_scope=(@aius_scope) end
	def aius_scope
		@aius_scope
	end
end

Kemal.config.extra_options = ->(opts : OptionParser) {
	opts.on("-o URL", "--otan URL", "Authentication server location.") do |opt|
		Kemal.config.aius_otan = opt
	end

	opts.on("-e SCOPE", "--scope SCOPE", "Required scope to authenticate users.") do |opt|
		Kemal.config.aius_scope = opt
	end

	nil
}

Kemal.run

