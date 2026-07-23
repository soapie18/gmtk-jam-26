extends Node2D

@onready var grass_button: ChangeSceneButton = $CanvasLayer/GrassButton

signal scene_changed(target_scene_name: String)

func _ready() -> void:
	grass_button.passed_target_information.connect(handle_scene_request)

func handle_scene_request(target_scene_name) -> void:
	scene_changed.emit(target_scene_name)
