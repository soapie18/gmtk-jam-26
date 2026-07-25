extends Node2D

@onready var main_menu = preload("res://Menus/main_menu.tscn")
@onready var grass_scene = preload("res://Garden/Scenes/Grass/GrassScene.tscn")
@onready var treetop_scene = preload("res://Garden/Scenes/Treetop/TreetopScene.tscn")
@onready var pond_scene = preload("res://Garden/Scenes/Pond/PondScene.tscn")

@onready var pause_menu = $"../PauseWindow"

var current_scene_instance
var main_menu_instance
var grass_scene_instance
var treetop_scene_instance
var pond_scene_instance

signal scene_inventory_changed(item_name_tag: String)

signal minigame_requested_in_scene(minigame_name_tag: String)

func _ready() -> void:
	# Instantiating all 4 scenes to be added and removed from tree freely.
	main_menu_instance = main_menu.instantiate()
	grass_scene_instance = grass_scene.instantiate()
	treetop_scene_instance = treetop_scene.instantiate()
	pond_scene_instance = pond_scene.instantiate()
	
	# Booting up the main menu as the current level on launch.
	current_scene_instance = main_menu_instance
	add_child(current_scene_instance)
	
	# Connecting to the signal emitted in first scene, which tells us
	# what scene is being requested via a string.
	current_scene_instance.scene_changed.connect(handle_scene_change)
	
	# Connecting to quit signals.
	pause_menu.quit_game.connect(handle_quit)
	main_menu_instance.quit_game.connect(handle_quit)

func handle_scene_change(target_scene_name: String) -> void:
	var new_scene_instance
	
	# Seeing which scene is requested from signal sent. Assigning it to
	# new_scene_instance to be added to tree soon.
	match target_scene_name:
		"main menu":
			new_scene_instance = main_menu_instance
		"grass":
			new_scene_instance = grass_scene_instance
		"treetop":
			new_scene_instance = treetop_scene_instance
		"pond":
			new_scene_instance = pond_scene_instance
		_:
			return
	
	# Adding the chosen scene.
	add_child(new_scene_instance)
	
	new_scene_instance.scene_changed.connect(handle_scene_change)
	new_scene_instance.item_picked_up_in_scene.connect(handle_item_picked_up)
	new_scene_instance.minigame_requested_in_scene.connect(handle_minigame_request)
	
	# Cleanup of previous scene.
	current_scene_instance.scene_changed.disconnect(handle_scene_change)
	current_scene_instance.item_picked_up_in_scene.disconnect(handle_item_picked_up)
	current_scene_instance.minigame_requested_in_scene.disconnect(handle_minigame_request)
	
	remove_child(current_scene_instance)
	current_scene_instance = new_scene_instance


func handle_item_picked_up(item_name_tag: String, _scene_name: String) -> void:
	# Picked up in player_script.
	scene_inventory_changed.emit(item_name_tag)

func handle_minigame_request(minigame_name_tag: String):
	# Picked up in minigame_manager.
	minigame_requested_in_scene.emit(minigame_name_tag)

func handle_quit() -> void:
	# Freeing scenes from memory.
	main_menu_instance.queue_free()
	grass_scene_instance.queue_free()
	treetop_scene_instance.queue_free()
	pond_scene_instance.queue_free()
	
	# Quitting game safely.
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
