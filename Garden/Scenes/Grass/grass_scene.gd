extends Node2D

@onready var treetop_button: ChangeSceneButton = $CanvasLayer/TreetopButton
@onready var pond_button: ChangeSceneButton = $CanvasLayer/PondButton

signal scene_changed(target_scene_name: String)

func _ready() -> void:
	treetop_button.passed_target_information.connect(handle_scene_request)
	pond_button.passed_target_information.connect(handle_scene_request)

func handle_scene_request(target_scene_name) -> void:
	scene_changed.emit(target_scene_name)
