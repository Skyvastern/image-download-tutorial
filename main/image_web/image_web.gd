extends ColorRect
class_name ImageWeb

@export var image_tr: TextureRect
@export var image_status: ImageStatus
@export var image_download_api: ImageDownloadAPI


func _ready() -> void:
	image_download_api.processed.connect(_on_image_download_api_processed)
	
	_reset_state()


func _reset_state() -> void:
	image_tr.texture = null
	image_tr.visible = false
	image_status.hide_status()


func download_image(url: String) -> void:
	image_status.show_status("Downloading image...")
	image_download_api.download(url)


func _on_image_download_api_processed(
	result: int,
	response_code: int,
	body: PackedByteArray,
	current_file_type: String
	
) -> void:
	
	if result != HTTPRequest.RESULT_SUCCESS or response_code != 200:
		image_status.show_error("Image couldn't be downloaded.")
		return
	
	var image: Image = Image.new()
	var error: Error = FAILED
	
	match current_file_type:
		"png":
			error = image.load_png_from_buffer(body)
		
		"jpg":
			error = image.load_jpg_from_buffer(body)
		
		"svg":
			error = image.load_svg_from_buffer(body)
		
		"webp":
			error = image.load_webp_from_buffer(body)
		
		"bmp":
			error = image.load_bmp_from_buffer(body)
		
		"tga":
			error = image.load_tga_from_buffer(body)
		
		"ktx":
			error = image.load_ktx_from_buffer(body)
		
		_:
			error = FAILED
	
	if error != OK:
		image_status.show_error("Image cannot be loaded.")
		return
	
	image_status.hide_status()
	image_tr.texture = ImageTexture.create_from_image(image)
	image_tr.visible = true
