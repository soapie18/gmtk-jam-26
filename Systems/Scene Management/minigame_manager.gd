extends Node2D

@onready var scene_manager = $"../SceneManager"

# For when a minigame needs to be instantiated on request.
@onready var pond_minigame_file = preload("res://Minigame Files/FishingGame/fishing_pond.tscn")
@onready var nest_minigame_file
@onready var leaves_minigame_file
@onready var wasps_minigame_file
@onready var spider_minigame_file
@onready var branch_minigame_file
@onready var bowl_minigame_file

var selected_minigame: PackedScene
var current_active_minigame
var cleanup_function

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
			
			cleanup_function = Callable(fishing_minigame_end)
		"nest":
			selected_minigame = nest_minigame_file
			
			items_required_for_minigame.append("feather")
			items_required_for_minigame.append("twig")
			
			cleanup_function = Callable(nest_minigame_end)
		"leaves":
			selected_minigame = leaves_minigame_file
			
			items_required_for_minigame.append("monarch caterpillar")
			
			cleanup_function = Callable(leaves_task_end)
		"wasps":
			selected_minigame = wasps_minigame_file
			
			cleanup_function = Callable(wasps_minigame_end)
		"spider":
			selected_minigame = spider_minigame_file
			
			cleanup_function = Callable(spider_minigame_end)
		"branch":
			selected_minigame = branch_minigame_file
			
			items_required_for_minigame.append("moth caterpillar")
			items_required_for_minigame.append("apple")
			
			cleanup_function = Callable(feed_moths_task_end)
		"cat bowl":
			selected_minigame = bowl_minigame_file
			
			items_required_for_minigame.append("fish")
			
			cleanup_function = Callable(cat_bowl_task_end)
		_:
			return
	
	# Picked up in player.
	minigame_inventory_query.emit(items_required_for_minigame)
	
	if can_start_minigame:
		print("ready to start this minigame!")
		current_active_minigame = selected_minigame.instantiate()
		add_child(current_active_minigame)
		
		# Every minigame/task will have a signal called this, but will be
		# connected to a unique function to handle its cleanup, as found
		# below. As such ensure all necessary params are passed to the function
		# from the signal. 
		current_active_minigame.finished_task.connect(cleanup_function)


func cleanup_minigame() -> void:
	current_active_minigame.queue_free()

# These functions will be tied to signals emitted within the games/tasks in
# question. They handle the outcomes of the task/game. may disable replay, may
# add loot to inventory, change sprites, and more depending on the minigame/task 
# in question.
# NOTE - its important that the parameters match up to the ones passed from the
# signal finished_task emitted from in game. 

func fishing_minigame_end(success: bool) -> void:
	print("fishing game terminated")
	cleanup_minigame()
	
	# Adding fish loot to inventory.
	if success:
		pass
	else:
		pass

# TODO: sophie's task
func leaves_task_end() -> void:
	cleanup_minigame()

# TODO: sophie's task
func cat_bowl_task_end() -> void:
	cleanup_minigame()

func nest_minigame_end() -> void:
	cleanup_minigame()

func wasps_minigame_end() -> void:
	cleanup_minigame()

func spider_minigame_end() -> void:
	cleanup_minigame()

# TODO: sophie's task
func feed_moths_task_end() -> void:
	cleanup_minigame()

# TODO: sophie's task
func water_plants_task_end() -> void:
	cleanup_minigame()
