extends Label
class_name ImageStatus

@export var default_color: Color
@export var error_color: Color
@export var anim_player: AnimationPlayer


func hide_status() -> void:
	visible = false


func show_status(message: String) -> void:
	text = message
	self_modulate = default_color
	visible = true
	
	anim_player.play("processing")


func show_error(message: String) -> void:
	text = message
	self_modulate = error_color
	visible = true
	
	anim_player.play("idle")
