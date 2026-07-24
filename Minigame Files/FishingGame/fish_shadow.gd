extends Node2D

@onready var fih_button = $FihButton

enum fish_type {
	#put them here
}

signal start_fishing#fish type as param

func _on_start_game_trigger_pressed() -> void:
	print("shadow clicked")
	#feed this emit some fish type param
	start_fishing.emit(fish_type)
