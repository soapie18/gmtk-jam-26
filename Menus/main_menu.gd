extends Node2D

@onready var play_button: ChangeSceneButton = $CanvasLayer/VBoxContainer/ChangeSceneButton

signal scene_changed(target_scene_name: String)
signal quit_game()

# Please ignore, I had to include it so that scene_manager wouldn't kick off
@warning_ignore("unused_signal")
signal item_picked_up_in_scene(item_name_tag: String)
@warning_ignore("unused_signal")
signal minigame_requested_in_scene(minigame_name_tag: String)

func _ready() -> void:
	play_button.passed_target_information.connect(handle_scene_request)

func handle_scene_request(target_scene_name: String) -> void:
	scene_changed.emit(target_scene_name)

func _on_quit_pressed() -> void:
	quit_game.emit()
