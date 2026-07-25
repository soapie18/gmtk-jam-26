extends Node2D

@export var scene_name: String

# Navigation buttons to other scenes.
@onready var treetop_button: ChangeSceneButton = $CanvasLayer/TreetopButton
@onready var pond_button: ChangeSceneButton = $CanvasLayer/PondButton

# Pickups found in this scene.
@onready var feather_pickup = $FeatherPickup
@onready var twig_pickup = $TwigPickup
@onready var monarch_caterpillars = $MonarchCaterpillarPickup

# Flowers in this scene.
@onready var flowers = $Flowers

# Minigames found in this scene.
@onready var leaves = $Leaves

signal scene_changed(target_scene_name: String)

signal item_picked_up_in_scene(item_name_tag: String, scene_name: String)

signal minigame_requested_in_scene(minigame_name_tag: String)

signal flowers_watered(identifier: String)

func _ready() -> void:
	# Connecting to signals to be the middleman between buttons pressed and 
	# the scene_manager.
	treetop_button.passed_target_information.connect(handle_scene_request)
	pond_button.passed_target_information.connect(handle_scene_request)
	
	# Connecting to signal that emits message that an item has been removed from
	# this scene, which scene_manager and player will want to know. 
	feather_pickup.item_collected.connect(respond_to_item_pickup)
	twig_pickup.item_collected.connect(respond_to_item_pickup)
	monarch_caterpillars.item_collected.connect(respond_to_item_pickup)
	
	# Connecting to signal emitted by minigame items to say a minigame has
	# been requested. Minigame manager and inventory will also be involved.
	leaves.minigame_requested.connect(handle_minigame_request)
	
	flowers.flowers_watered.connect(handle_flowers_watered)


func handle_minigame_request(minigame_name_tag: String):
	# Picked up in scene_manager.
	minigame_requested_in_scene.emit(minigame_name_tag)


func handle_scene_request(target_scene_name) -> void:
	# Picked up in scene_manager.
	scene_changed.emit(target_scene_name)


func respond_to_item_pickup(item_name_tag: String):
	# Picked up in scene_manager.
	item_picked_up_in_scene.emit(item_name_tag, scene_name)

func handle_flowers_watered(identifier: String) -> void:
	flowers_watered.emit(identifier)
