extends Node2D

@onready var scene_manager = $"../SceneManager"

@onready var day_end_screen = preload("res://Systems/Scene Management/day_end_screen.tscn")
var day_end_screen_instance

@onready var gameover_screen1 = preload("res://Systems/Scene Management/Gameover Scenarios/gameover_1.tscn")
@onready var gameover_screen2 = preload("res://Systems/Scene Management/Gameover Scenarios/gameover_2.tscn")

var day_index: int

# Day one conditions to progress to Day 2.
var flowers_1_watered: bool
var flowers_2_watered: bool

var nest_fixed: bool

# Day two conditions to progress to Day 3.
var caterpillars_fed: bool
var larvae_fed: bool

# For each new day
signal alter_grass_scene
signal alter_treetop_scene
signal alter_pond_scene


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


func trigger_day_end_anim_day1(canvas_instance) -> void:
	canvas_instance.label.text = "Day 1"
	
	var screen_tween = create_tween()
	screen_tween.tween_property(canvas_instance.color_rect, "modulate", Color.WHITE, 5)
	
	canvas_instance.label.text = "Day 2" 
	
	var screen_fade = create_tween()
	screen_fade.tween_property(canvas_instance.color_rect, "modulate", Color(100, 100, 100, 0), 5)
	
	canvas_instance.color_rect.Color(0, 0, 0, 1)



func trigger_day_end_anim_day2(canvas_instance) -> void:
	canvas_instance.label.text = "Day 2"
	
	var screen_tween = create_tween()
	screen_tween.tween_property(canvas_instance.color_rect, "modulate", Color.WHITE, 5)
	
	canvas_instance.label.text = "Day 3"
	
	var screen_fade = create_tween()
	screen_fade.tween_property(canvas_instance.color_rect, "modulate", Color(100, 100, 100, 0), 5)
	
	canvas_instance.color_rect.Color(0, 0, 0, 1)



func handle_day_ended() -> void:
	
	match day_index:
		1:
			if !flowers_1_watered || !flowers_2_watered:
				trigger_gameover_day1()
			else:
				trigger_day_end_anim_day1(day_end_screen_instance)
				setup_day2()
		2:
			if !caterpillars_fed || !larvae_fed:
				trigger_gameover_day2()
			else:
				trigger_day_end_anim_day2(day_end_screen_instance)
				setup_day3()
		3:
			roll_credits()
		_:
			return
	
	day_index += 1


func trigger_gameover_day1() -> void:
	var gameover_screen_instance = gameover_screen1.instantiate()
	add_child(gameover_screen_instance)
	
	#QUIT GAME

func trigger_gameover_day2() -> void:
	var gameover_screen_instance = gameover_screen2.instantiate()
	add_child(gameover_screen_instance)
	
	#QUIT GAME

func setup_day2() -> void:
	pass

func setup_day3() -> void:
	pass

func roll_credits() -> void:
	pass
