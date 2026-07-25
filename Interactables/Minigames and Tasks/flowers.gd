extends Node2D

@export var flower_identifier: String

@onready var sprite = $Sprite2D
var inbloom_texture #PUT PRELOAD OF TEXTURE HERE

var watered: bool = false

signal flowers_watered(identifier)

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if !flowers_watered:
				sprite.texture = inbloom_texture
			
			watered = true
			
			flowers_watered.emit(flower_identifier)
