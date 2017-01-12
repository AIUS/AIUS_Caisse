require "http/client"
require "json"
require "readline"

OTAN = "https://otan.aius.u-strasbg.fr"
SALES = "http://localhost:3000"

token = nil

STDIN << "Login: "
STDIN.flush
login = STDIN.read_line

STDIN << "Password: "
STDIN.flush
password = STDIN.noecho &.gets.try &.chomp

def ask_nicely(type, url, body)
	headers = HTTP::Headers {
		"Content-Type" => "application/json"
	}

	if type == :post
		HTTP::Client.post url, headers: headers, body: body.to_json
	elsif type == :delete
		HTTP::Client.delete url, headers: headers, body: body.to_json
	else type == :get
		HTTP::Client.get url, headers: headers
	end
end

def post(url, body)
	ask_nicely :post, url, body
end

def delete(url, body)
	ask_nicely :delete, url, body
end

def get(url)
	ask_nicely :get, url, {} of String => String
end

response = post OTAN + "/token", {
	"username" => login,
	"password" => password,
}

if response.status_code == 200
	response = JSON.parse response.body

	if response["token"]
		puts "Connected."
		token = response["token"]
	else
		puts "No token received. Dying nao."

		exit
	end
else
	puts "HTTP error (#{response.status_code})."
	puts response
	STDOUT << response.body

	puts "Could not authenticate. Dying nao."

	exit
end

commands = Hash(String, NamedTuple(help: String, exec: Proc(Array(String), Nil))) {
	"sales" => {
		help: "List products on sale.",
		exec: ->(arg : Array(String)) {
			answer = JSON.parse get(SALES + "/products").body

			answer.each do |product|
				puts "#{product["id"]}: #{product["name"]} - #{product["price"]}"
			end

			return
		}
	},
	"new-product" => {
		help: "Add a product to the sales list.",
		exec: ->(arg : Array(String)) {
			if ! arg[2]?
				puts "usage: sell <name> <price>"

				return
			end

			name = arg[1].to_s
			price = arg[2].to_f64

			answer = JSON.parse post(SALES + "/products", {
				"name" => name,
				"price" => price,
				"token" => token
			}).body

			puts answer

			return
		}
	},
}

commands["help"] = {
	help: "Lists the available commands.",
	exec: ->(arg : Array(String)) {
		commands.each do |command, data|
			puts "#{command}: #{data[:help]}"
		end

		return
	}
}

while line = Readline.readline "> "
	arg = line.split /[ \t]+/

	if commands[arg[0]]?
		commands[arg[0]][:exec].call arg
	elsif arg[0] == "delete-product"
		if ! arg[1]?
			puts "usage: delete-product <id>"

			next
		end

		id = arg[1].to_i
		answer = delete(SALES + "/product/#{id}", {
			"token" => token
		}).body
		puts answer
	elsif arg[0] == "sell"
		if ! arg[1]?
			puts "usage: sell <id>"

			next
		end

		id = arg[1].to_i

		puts "id: #{id}"


	else
		puts "Unknown command: #{arg[0]}"
	end
end

