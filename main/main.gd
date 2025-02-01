extends Control
class_name Main

@export var image_web: ImageWeb


func _ready() -> void:
	image_web.download_image("https://godotengine.org/assets/press/logo_vertical_color_light.png")
