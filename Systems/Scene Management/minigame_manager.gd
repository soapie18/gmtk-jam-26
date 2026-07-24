extends Node2D

@onready var scene_manager = $"../SceneManager"

# For when a minigame needs to be instantiated on request.
@onready var pond_minigame_file
@onready var nest_minigame_file
@onready var leaves_minigame_file
@onready var wasps_minigame_file
@onready var spider_minigame_file
@onready var branch_minigame_file
@onready var bowl_minigame_file

var selected_minigame: PackedScene
var current_active_minigame

var items_required_for_minigame: Array

var can_start_minigame: bool = false

signal minigame_inventory_query(items_required: Array)

func _ready() -> void:
	scene_manager.minigame_requested_in_scene.connect(handle_minigame_request)

func handle_minigame_request(minigame_name_tag) -> void:
	# Resetting the list from last time.
	items_required_for_minigame.resize(0)
	# Checking which minigame was requested, adding to the list to be
	# checked against the inventory.
	match minigame_name_tag:
		"pond":
			selected_minigame = pond_minigame_file
		"nest":
			selected_minigame = nest_minigame_file
			
			items_required_for_minigame.append("feather")
			items_required_for_minigame.append("twig")
		"leaves":
			selected_minigame = leaves_minigame_file
			
			items_required_for_minigame.append("monarch caterpillar")
		"wasps":
			selected_minigame = wasps_minigame_file
		"spider":
			selected_minigame = spider_minigame_file
		"branch":
			selected_minigame = branch_minigame_file
			
			items_required_for_minigame.append("moth caterpillar")
			items_required_for_minigame.append("apple")
		"cat bowl":
			selected_minigame = bowl_minigame_file
			
			items_required_for_minigame.append("fish")
		_:
			return
	
	# Picked up in player.
	minigame_inventory_query.emit(items_required_for_minigame)
	
	if can_start_minigame:
		print("ready to start this minigame!")
		#current_active_minigame = selected_minigame.instantiate()
		#add_child(current_active_minigame)


func cleanup_minigame() -> void:
	# TODO: handle what happens if you win or lose the minigame.
	# make a func for each minigame in order to respond to a unique signal from each on game end.
	# use this func as a queue free only. 
	
	current_active_minigame.queue_free()

# These functions will be tied to signals emitted within the games/tasks in
# question. They handle the outcomes of the task/game. may disable replay, may
# add loot to inventory, change sprites, and more depending on the minigame/task 
# in question.
func fishing_minigame_end() -> void:
	cleanup_minigame()
	pass

func leaves_task_end() -> void:
	cleanup_minigame()
	pass

func cat_bowl_task_end() -> void:
	cleanup_minigame()
	pass

func nest_minigame_end() -> void:
	cleanup_minigame()
	pass

func wasps_minigame_end() -> void:
	cleanup_minigame()
	pass

func spider_minigame_end() -> void:
	cleanup_minigame()
	pass

func feed_moths_task_end() -> void:
	cleanup_minigame()
	pass

func water_plants_task_end() -> void:
	cleanup_minigame()
	pass
