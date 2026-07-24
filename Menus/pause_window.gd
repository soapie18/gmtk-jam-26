extends CanvasLayer

@onready var player = $"../Player"

signal handle_quit

func _ready() -> void:
	visible = false
	player.game_paused.connect(on_game_paused)

func on_game_paused() -> void:
	visible = true

func on_resume() -> void:
	visible = false

func on_quit() -> void:
	handle_quit.emit()
