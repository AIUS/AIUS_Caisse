
def error(message)
	{
		"status" => "error",
		"message" => message,
	}.to_json
end

