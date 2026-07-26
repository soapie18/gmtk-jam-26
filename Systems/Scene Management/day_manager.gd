extends Node2D

@onready var scene_manager = $"../SceneManager"
@onready var minigame_manager = $"../MinigameManager"

@onready var day_end_screen = preload("res://Systems/Scene Management/day_end_screen.tscn")
var day_end_screen_instance

@onready var gameover_screen1 = preload("res://Systems/Scene Management/Gameover Scenarios/gameover_1.tscn")
@onready var gameover_screen2 = preload("res://Systems/Scene Management/Gameover Scenarios/gameover_2.tscn")
@onready var win_screen = preload("res://Systems/Scene Management/win_screen.tscn")

var day_index: int = 1

# Day one conditions to progress to Day 2.
var flowers_1_watered: bool
var flowers_2_watered: bool

var nest_fixed: bool = false

# Day two conditions to progress to Day 3.
var caterpillars_fed: bool
var larvae_fed: bool

signal audio_change_request

func _ready() -> void:
	
	day_end_screen_instance = day_end_screen.instantiate()
	
	scene_manager.flowers_watered.connect(update_flowers_watered)


func update_flowers_watered(identifier: String) -> void:
	
	match identifier:
		"grass":
			flowers_1_watered = true
			print("flowers in grass scene watered:")
			print(flowers_1_watered)
		"pond":
			flowers_2_watered = true
			print("flowers in grass scene watered:")
			print(flowers_2_watered)


func customise_day_end_screen() -> void:
	day_end_screen_instance.label.text = "Night has fallen on day two..."
	day_end_screen_instance.sprite.texture = load("res://Interactables/Pickups/Pickups - Art/Cocoon.png")
	day_end_screen_instance.sprite2.texture = load("res://Interactables/Pickups/Pickups - Art/Chrysalis.png")
	day_end_screen_instance.sprite3.texture = load("res://Interactables/Pickups/Pickups - Art/Chrysalis.png")


func handle_day_ended() -> void:
	print("day manager reached")
	match day_index:
		1:
			if !caterpillars_fed || !larvae_fed:
				add_child(day_end_screen_instance)
				await get_tree().create_timer(3).timeout
				
				trigger_gameover_day1()
				
				remove_child(day_end_screen_instance)
			else:
				add_child(day_end_screen_instance)
				await get_tree().create_timer(3).timeout
				
				setup_day2()
				
				remove_child(day_end_screen_instance)
		2:
			if !flowers_1_watered || !flowers_2_watered:
				customise_day_end_screen()
				
				add_child(day_end_screen_instance)
				await get_tree().create_timer(3).timeout
				
				trigger_gameover_day2()
				
				remove_child(day_end_screen_instance)
			else:
				add_child(day_end_screen_instance)
				await get_tree().create_timer(3).timeout
				
				setup_day3()
				
				remove_child(day_end_screen_instance)
		3:
			roll_credits()
		_:
			return
	
	day_index += 1


func trigger_gameover_day1() -> void:
	audio_change_request.emit(8)
	
	var gameover_screen_instance = gameover_screen1.instantiate()
	add_child(gameover_screen_instance)
	
	await get_tree().create_timer(10).timeout
	
	gameover_screen_instance.queue_free()
	day_end_screen_instance.queue_free()
	
	scene_manager.handle_quit()


func trigger_gameover_day2() -> void:
	audio_change_request.emit(8)
	
	var gameover_screen_instance = gameover_screen2.instantiate()
	add_child(gameover_screen_instance)
	
	await get_tree().create_timer(10).timeout
	
	gameover_screen_instance.queue_free()
	day_end_screen_instance.queue_free()
	
	scene_manager.handle_quit()


func setup_day2() -> void:
	# Change branch scene for closeup.
	minigame_manager.branch_minigame_file = preload("res://Minigame Files/BranchScene/BranchSceneDay2.tscn")
	# Change leaves scene for closeup.
	minigame_manager.leaves_minigame_file = preload("res://Minigame Files/LeavesScene/leaves_scene_day2.tscn")
	# Reset flowers to wilted.
	scene_manager.set_flowers_wilted("grass")
	scene_manager.set_flowers_wilted("pond")
	flowers_1_watered = false
	flowers_2_watered = false
	# Update nest sprite based on nest fixed status.
	if nest_fixed:
		scene_manager.change_nest_sprite("3 hatchlings")
	else:
		scene_manager.change_nest_sprite("2 hatchlings")


func setup_day3() -> void:
	# Change branch scene for closeup.
	minigame_manager.branch_minigame_file = preload("res://Minigame Files/BranchScene/BranchSceneDay3.tscn")
	# Change leaves scene for closeup.
	minigame_manager.leaves_minigame_file = preload("res://Minigame Files/LeavesScene/leaves_scene_day3.tscn")
	# Spawn butterflies and moths.
	scene_manager.spawn_butterflies()

func roll_credits() -> void:
	audio_change_request.emit(0)
	
	var win_screen_instance = win_screen.instantiate()
	add_child(win_screen_instance)
	
	win_screen_instance.queue_free()
	day_end_screen_instance.queue_free()
	
	scene_manager.handle_quit()
