extends Node2D

@onready var play_button: ChangeSceneButton = $CanvasLayer/VBoxContainer/ChangeSceneButton

signal scene_changed(target_scene_name: String)

func _ready() -> void:
	play_button.passed_target_information.connect(handle_scene_request)

func handle_scene_request(target_scene_name: String) -> void:
	scene_changed.emit(target_scene_name)
