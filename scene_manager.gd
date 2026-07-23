extends Node2D

@onready var main_menu = preload("res://Menus/main_menu.tscn")
@onready var garden_scene = preload("res://Garden/garden_scene.tscn")
@onready var pause_menu = preload("res://Menus/pause_window.tscn")

# Making main menu default value to allow it to be instantiated on launch.
@onready var current_scene: PackedScene = main_menu
@onready var current_active_scene = current_scene

func _ready() -> void:
	# Booting up the main menu as the current level on launch.
	current_active_scene = current_scene.instantiate()
	add_child(current_active_scene)
	
	# Connecting to the signal emitted in each scene, which carries the scene
	# name as an argument.
	current_active_scene.scene_changed.connect(handle_scene_change)
	
	#pause_menu.game_paused.connect(handle_pause)

func handle_scene_change(current_scene_name: String) -> void:
	var new_scene: PackedScene
	
	# Seeing which scene is currently active based on signal sent by it,
	# then preparing which scene will be loaded instead.
	match current_scene_name:
		"main menu":
			new_scene = garden_scene
		"garden":
			new_scene = main_menu
		_:
			return
	
	# Instantiating the new scene.
	var new_scene_instance = new_scene.instantiate()
	add_child(new_scene_instance)
	
	# Cleanup and preparing for next time a switch is required.
	current_active_scene.queue_free()
	current_scene = new_scene


func handle_pause() -> void:
	pass
