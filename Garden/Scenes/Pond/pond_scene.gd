extends Node2D

@export var scene_name: String

# Navigation buttons to other scenes. 
@onready var grass_button: ChangeSceneButton = $Canvas/GrassButton

# Pickups found in this scene.
@onready var moth_caterpillar = $MothCaterpillarPickup

# Minigames found in this scene.
@onready var pond = $Pond
@onready var branch = $Branch

@onready var flowers = $Flowers

signal scene_changed(target_scene_name: String)

signal item_picked_up_in_scene(item_name_tag: String, scene_name: String)

signal minigame_requested_in_scene(minigame_name_tag: String)

signal flowers_watered(identifier: String)

func _ready() -> void:
	# Connecting to signals to be the middleman between buttons pressed and 
	# the scene_manager.
	grass_button.passed_target_information.connect(handle_scene_request)
	
	# Connecting to signal that emits message that an item has been removed from
	# this scene, which scene_manager and player will want to know.
	moth_caterpillar.item_collected.connect(respond_to_item_pickup)
	
	# Connecting to signal emitted by minigame items to say a minigame has
	# been requested. Minigame manager and inventory will also be involved.
	pond.minigame_requested.connect(handle_minigame_request)
	branch.minigame_requested.connect(handle_minigame_request)
	
	flowers.flowers_watered.connect(handle_flowers_watered)

func handle_scene_request(target_scene_name) -> void:
	# Picked up in scene_manager.
	scene_changed.emit(target_scene_name)

func respond_to_item_pickup(item_name_tag: String):
	# Picked up in scene_manager.
	item_picked_up_in_scene.emit(item_name_tag, scene_name)

func handle_minigame_request(minigame_name_tag: String):
	# Picked up in scene_manager.
	minigame_requested_in_scene.emit(minigame_name_tag)

func handle_flowers_watered(identifier: String) -> void:
	flowers_watered.emit(identifier)
