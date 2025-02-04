extends HTTPRequest
class_name ImageDownloadAPI

signal res_received
signal req_failed

var image_load_method: String
var valid_types: Dictionary = {
	"image/png": "load_png_from_buffer",
	"image/jpeg": "load_jpg_from_buffer",
	"image/svg+xml": "load_svg_from_buffer",
	"image/webp": "load_webp_from_buffer",
	"image/bmp": "load_bmp_from_buffer"
}


func _ready() -> void:
	request_completed.connect(_on_request_completed)


func download(url: String) -> void:
	var error: Error = request(url)
	
	if error != OK:
		req_failed.emit()


func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	# Get image type and its respective GDScript method
	var content_type: String = ""
	
	for val in headers:
		if val.begins_with("Content-Type: "):
			content_type = val.split("Content-Type: ")[1]
			break
	
	image_load_method = valid_types.get(content_type, "")
	
	# Emit signal with all details
	res_received.emit(result, response_code, body, image_load_method)
