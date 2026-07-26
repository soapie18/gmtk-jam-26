extends Node2D

signal finished_task

func _on_button_pressed() -> void:
	finished_task.emit()
