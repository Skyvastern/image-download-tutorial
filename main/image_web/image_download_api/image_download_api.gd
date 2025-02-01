extends HTTPRequest
class_name ImageDownloadAPI

signal processed

var current_file_type: String


func _ready() -> void:
	request_completed.connect(_on_request_completed)


func download(url: String) -> void:
	current_file_type = url.split(".")[-1]
	request(url)


func _on_request_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	processed.emit(result, response_code, body, current_file_type)
