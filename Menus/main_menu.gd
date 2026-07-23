extends Node2D

@export var scene_name: String

signal scene_changed(current_scene_name: String)


# Play button.
func _on_button_pressed() -> void:
	scene_changed.emit("main menu")
