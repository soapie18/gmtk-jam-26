class_name ChangeSceneButton extends Button

@export var target_name: String

signal passed_target_information(target_scene_name: String)

func _on_pressed() -> void:
	# Picked up in scene the button is in.
	passed_target_information.emit(target_name)
