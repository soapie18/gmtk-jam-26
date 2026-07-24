extends Node2D

@onready var fishing_game = preload("res://Minigame Files/FishingGame/fishing_game.tscn")
var fishing_game_instance

@onready var fish_shadow_1 = $FishShadow
@onready var fish_shadow_2 = $FishShadow2
@onready var fish_shadow_3 = $FishShadow3

signal finished_task(success: bool)

func _ready() -> void:
	fishing_game_instance = fishing_game.instantiate()
	fishing_game_instance.finished_task.connect(cleanup_fishing_game)
	
	fish_shadow_1.start_fishing.connect(start_fishing_game)
	fish_shadow_2.start_fishing.connect(start_fishing_game)
	fish_shadow_3.start_fishing.connect(start_fishing_game)

func start_fishing_game(fish_type) -> void:
	fish_shadow_1.fih_button.disabled = true
	fish_shadow_2.fih_button.disabled = true
	fish_shadow_3.fih_button.disabled = true
	
	#change details regarding fish type here, before adding to tree.
	add_child(fishing_game_instance)

func cleanup_fishing_game(success: bool) -> void:
	fishing_game_instance.queue_free()
	
	finished_task.emit(success)
	
	fish_shadow_1.fih_button.disabled = false
	fish_shadow_2.fih_button.disabled = false
	fish_shadow_3.fih_button.disabled = false
