extends Node2D

@export var minigame_tag: String

@onready var sprite = $Sprite2D
@onready var audio = $AudioStreamPlayer

signal minigame_requested(mingame_name_tag: String)

func _ready() -> void:
	pass 



func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			# Connected to in scene the minigame belongs in, e.g grass scene.
			minigame_requested.emit(minigame_tag)
			
			audio.play()
