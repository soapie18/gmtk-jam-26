extends Node2D

@onready var scene_manager = $"../SceneManager"
@onready var day_manager = $"../DayManager"

# For when a minigame needs to be instantiated on request.
@onready var pond_minigame_file = preload("res://Minigame Files/FishingGame/fishing_pond.tscn")
@onready var nest_minigame_file = preload("res://Minigame Files/NestRepairGame/PigeonNestRepair.tscn")
@onready var leaves_minigame_file = preload("res://Minigame Files/LeavesScene/leaves_scene.tscn")
@onready var branch_minigame_file = preload("res://Minigame Files/BranchScene/branch_scene.tscn")

var selected_minigame: PackedScene
var current_active_minigame
var cleanup_function

var items_required_for_minigame: Array

var can_start_minigame: bool = false

signal minigame_inventory_query(items_required: Array)
signal add_loot_to_inventory(loot: String)
signal audio_change_request(audio_index: int)

func _ready() -> void:
	scene_manager.minigame_requested_in_scene.connect(handle_minigame_request)

func handle_minigame_request(minigame_name_tag) -> void:
	var chosen_audio_index
	
	# Resetting the list from last time.
	items_required_for_minigame.resize(0)
	# Checking which minigame was requested, adding to the list to be
	# checked against the inventory.
	match minigame_name_tag:
		"pond":
			selected_minigame = pond_minigame_file
			
			cleanup_function = Callable(fishing_minigame_end)
			
			chosen_audio_index = 2
		"nest":
			selected_minigame = nest_minigame_file
			
			items_required_for_minigame.append("feather")
			items_required_for_minigame.append("twig")
			
			cleanup_function = Callable(nest_minigame_end)
			
			chosen_audio_index = 5
		"leaves":
			selected_minigame = leaves_minigame_file
			
			items_required_for_minigame.append("monarch caterpillar")
			
			cleanup_function = Callable(leaves_task_end)
			
			chosen_audio_index = 4
		"branch":
			selected_minigame = branch_minigame_file
			
			items_required_for_minigame.append("moth caterpillar")
			items_required_for_minigame.append("apple")
			
			cleanup_function = Callable(branch_task_end)
			
			chosen_audio_index = 4
		_:
			return
	
	# Picked up in player.
	minigame_inventory_query.emit(items_required_for_minigame)
	await get_tree().create_timer(0.3).timeout
	
	if can_start_minigame:
		print("ready to start this minigame!")
		current_active_minigame = selected_minigame.instantiate()
		add_child(current_active_minigame)
		
		audio_change_request.emit(chosen_audio_index)
		
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
	
	audio_change_request.emit(1)
	# Adding fish loot to inventory.
	if success:
		add_loot_to_inventory.emit("fish")
	else:
		pass

func leaves_task_end() -> void:
	audio_change_request.emit(1)
	cleanup_minigame()

func branch_task_end() -> void:
	audio_change_request.emit(1)
	cleanup_minigame()

func nest_minigame_end(success: bool) -> void:
	audio_change_request.emit(1)
	
	if success:
		scene_manager.change_nest_sprite("fixed")
		
		day_manager.nest_fixed = true

	cleanup_minigame()

func spider_minigame_end() -> void:
	audio_change_request.emit(1)
	cleanup_minigame()
