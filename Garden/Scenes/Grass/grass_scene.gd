extends Node2D

@export var scene_name: String

# Navigation buttons to other scenes.
@onready var treetop_button: ChangeSceneButton = $CanvasLayer/TreetopButton
@onready var pond_button: ChangeSceneButton = $CanvasLayer/PondButton

# Pickups found in this scene.
@onready var feather_pickup = $FeatherPickup
@onready var twig_pickup = $TwigPickup
@onready var monarch_caterpillar_1 = $MonarchCaterpillarPickup
@onready var monarch_caterpillar_2 = $MonarchCaterpillarPickup2
@onready var monarch_caterpillar_3 = $MonarchCaterpillarPickup3

signal scene_changed(target_scene_name: String)

signal item_picked_up_in_scene(item_name_tag: String, scene_name: String)

func _ready() -> void:
	# Connecting to signals to be the middleman between buttons pressed and 
	# the scene_manager.
	treetop_button.passed_target_information.connect(handle_scene_request)
	pond_button.passed_target_information.connect(handle_scene_request)
	
	# Connecting to signal that emits message that an item has been removed from
	# this scene, which scene_manager and player will want to know. 
	feather_pickup.item_collected.connect(respond_to_item_pickup)
	twig_pickup.item_collected.connect(respond_to_item_pickup)
	monarch_caterpillar_1.item_collected.connect(respond_to_item_pickup)
	monarch_caterpillar_2.item_collected.connect(respond_to_item_pickup)
	monarch_caterpillar_3.item_collected.connect(respond_to_item_pickup)

func handle_scene_request(target_scene_name) -> void:
	scene_changed.emit(target_scene_name)

func respond_to_item_pickup(item_name_tag: String):
	item_picked_up_in_scene.emit(item_name_tag, scene_name)

func setup_self() -> void:
	pass
