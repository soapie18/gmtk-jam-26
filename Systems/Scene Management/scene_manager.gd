extends Node2D

@onready var main_menu = preload("res://Menus/main_menu.tscn")
@onready var grass_scene = preload("res://Garden/Scenes/Grass/GrassScene.tscn")
@onready var treetop_scene = preload("res://Garden/Scenes/Treetop/TreetopScene.tscn")
@onready var pond_scene = preload("res://Garden/Scenes/Pond/PondScene.tscn")

@onready var pause_menu = preload("res://Menus/pause_window.tscn")

# Making main menu default value to allow it to be instantiated on launch.
@onready var current_scene: PackedScene = main_menu
var current_scene_instance

signal scene_inventory_changed(item_name_tag: String)

signal minigame_requested_in_scene(minigame_name_tag: String)

func _ready() -> void:
	# Booting up the main menu as the current level on launch.
	current_scene_instance = current_scene.instantiate()
	add_child(current_scene_instance)
	
	# Connecting to the signal emitted in each scene, which tells us
	# what scene is being requested via a string.
	current_scene_instance.scene_changed.connect(handle_scene_change)
	
	#current_scene_instance.item_collected.connect(handle_item_picked_up)
	
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
	new_scene_instance.item_picked_up_in_scene.connect(handle_item_picked_up)
	new_scene_instance.minigame_requested_in_scene.connect(handle_minigame_request)
	
	# Cleanup.
	current_scene_instance.queue_free()
	current_scene_instance = new_scene_instance


func handle_item_picked_up(item_name_tag: String, _scene_name: String) -> void:
	# Picked up in player_script.
	scene_inventory_changed.emit(item_name_tag)

func handle_minigame_request(minigame_name_tag: String):
	# Picked up in minigame_manager.
	minigame_requested_in_scene.emit(minigame_name_tag)

func handle_pause() -> void:
	pass
