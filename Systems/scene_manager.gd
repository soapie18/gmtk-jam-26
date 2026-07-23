extends Node2D

@onready var main_menu = load("res://Menus/main_menu.tscn")
@onready var grass_scene = load("res://Garden/Scenes/Grass/GrassScene.tscn")
@onready var treetop_scene = load("res://Garden/Scenes/Treetop/TreetopScene.tscn")
@onready var pond_scene = load("res://Garden/Scenes/Pond/PondScene.tscn")

@onready var pause_menu = load("res://Menus/pause_window.tscn")

# Making main menu default value to allow it to be instantiated on launch.
@onready var current_scene: PackedScene = main_menu
var current_scene_instance

func _ready() -> void:
	# Booting up the main menu as the current level on launch.
	current_scene_instance = current_scene.instantiate()
	add_child(current_scene_instance)
	
	# Connecting to the signal emitted in each scene, which tells us
	# what scene is being requested via a string.
	current_scene_instance.scene_changed.connect(handle_scene_change)
	
	###pause_menu.game_paused.connect(handle_pause)

func handle_scene_change(target_scene_name: String) -> void:
	var new_scene: PackedScene
	# Seeing which scene is requested from signal sent. Assigning it to
	# new_scene to be instantiated soon.
	match target_scene_name:
		"main menu":
			new_scene = main_menu
		"grass":
			new_scene = grass_scene
		"treetop":
			new_scene = treetop_scene
		"pond":
			new_scene = pond_scene
		_:
			return
	# Instantiating the new scene.
	var new_scene_instance = new_scene.instantiate()
	add_child(new_scene_instance)
	
	new_scene_instance.scene_changed.connect(handle_scene_change)
	# Cleanup.
	current_scene_instance.queue_free()
	current_scene_instance = new_scene_instance



func handle_pause() -> void:
	pass
