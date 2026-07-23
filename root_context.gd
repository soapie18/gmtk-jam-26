extends Node2D

var scene_manager = preload("res://Systems/scene_manager.tscn")

func _ready() -> void:
	var scene_manager_instance = scene_manager.instantiate()
	add_child(scene_manager_instance)
