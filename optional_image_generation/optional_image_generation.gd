# In some places I have written code in not so great way
# 1. Directly using methods of image_web.image_status doesn't feel right
# 2. Awaiting image_web.image_download_api.processed doesn't feel right too
#
# But for the scope of this demonstration of image download, I think its completely fine

extends Control
class_name OptionalImageGeneration

@export_group("UI")
@export var image_web: ImageWeb
@export var prompt_input: LineEdit
@export var generate_btn: Button

@export_group("References")
@export var image_generate_api: ImageGenerateAPI


func _ready() -> void:
	generate_btn.pressed.connect(_on_generate_btn_pressed)
	image_generate_api.processed.connect(_on_image_generated)


func _on_generate_btn_pressed() -> void:
	image_web.reset_state()
	image_web.image_status.show_status("Generating image...")
	
	prompt_input.editable = false
	generate_btn.disabled = true
	
	var prompt: String = prompt_input.text
	image_generate_api.make_request(prompt)


func _on_image_generated(result: int, response_code: int, json: Dictionary) -> void:
	if result != 0 or response_code != 200:
		image_web.image_status.show_error("An error occured generating image.")
		prompt_input.editable = true
		generate_btn.disabled = false
	
	else:
		image_web.image_status.hide_status()
		
		var image_url: String = json["data"][0]["url"]
		image_web.download_image(image_url)
		
		await image_web.image_download_api.processed
		prompt_input.editable = true
		generate_btn.disabled = false
