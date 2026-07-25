extends CanvasLayer

@onready var player = $"../Player"

signal quit_game

func _on_quit_pressed() -> void:
	on_quit()

func _on_resume_pressed() -> void:
	on_resume()

func _ready() -> void:
	visible = false
	player.game_paused.connect(on_game_paused)

func on_game_paused() -> void:
	visible = true
	get_tree().paused = true

func on_resume() -> void:
	visible = false
	get_tree().paused = false

func on_quit() -> void:
	quit_game.emit()
