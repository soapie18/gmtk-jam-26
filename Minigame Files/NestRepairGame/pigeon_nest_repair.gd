extends Node2D

signal finished_task(success: bool)

@onready var pigeon_nest = %PidgeonNest

func _ready() -> void:
	pigeon_nest.finished_task.connect(on_game_finished)
	
	await get_tree().create_timer(6).timeout
	finished_task.emit(false)

func on_game_finished(success: bool) -> void:
	finished_task.emit(success)
