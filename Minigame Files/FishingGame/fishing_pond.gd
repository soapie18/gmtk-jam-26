extends Node2D

@onready var fishing_game = preload("res://Minigame Files/FishingGame/fishing_game.tscn")
var fishing_game_instance

@onready var fish_shadow_1 = $FishShadow
@onready var fish_shadow_2 = $FishShadow2
@onready var fish_shadow_3 = $FishShadow3

signal fishing_complete(success: bool)

func _ready() -> void:
	fishing_game_instance = fishing_game.instantiate()
	
	fishing_game_instance.fishing_finished.connect(cleanup_fishing_game)
	
	fish_shadow_1.start_fishing.connect(start_fishing_game)
	fish_shadow_2.start_fishing.connect(start_fishing_game)
	fish_shadow_3.start_fishing.connect(start_fishing_game)

func start_fishing_game() -> void:
	add_child(fishing_game_instance)

func cleanup_fishing_game(success: bool) -> void:
	fishing_game_instance.queue_free()
	
	fishing_complete.emit(success)
