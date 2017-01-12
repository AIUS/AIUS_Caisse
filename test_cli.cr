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
	else type == :get
		HTTP::Client.get url, headers: headers
	end
end

def post(url, body)
	ask_nicely :post, url, body
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

while line = Readline.readline "> "
	arg = line.split /[ \t]+/

	if arg[0] == "sales"
		answer = JSON.parse get(SALES + "/products").body

		answer.each do |product|
			puts "#{product["id"]}: #{product["name"]} - #{product["price"]}"
		end
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

