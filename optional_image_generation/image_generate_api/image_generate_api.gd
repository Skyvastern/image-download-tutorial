extends HTTPRequest
class_name ImageGenerateAPI

signal res_received
var url: String = "https://api.openai.com/v1/images/generations"


func _ready() -> void:
	request_completed.connect(_on_request_completed)


func make_request(prompt: String) -> void:
	var headers: PackedStringArray = [
		"Content-Type: application/json",
		"Authorization: Bearer " + ENV.OPENAI_API_KEY
	]
	
	var body: String = JSON.stringify({
		"model": "dall-e-3",
		"prompt": prompt,
		"n": 1,
		"size": "1024x1024"
	})
	
	request(url, headers, HTTPClient.METHOD_POST, body)


func _on_request_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var json: Dictionary = {}
	
	if result == 0:
		json = JSON.parse_string(body.get_string_from_utf8())
	
	res_received.emit(result, response_code, json)
