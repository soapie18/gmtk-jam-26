extends Node2D

@onready var audio = $AudioStreamPlayer

signal finished_task

func _ready() -> void:
	audio.play()


func _on_exitbutton_pressed() -> void:
	finished_task.emit()
