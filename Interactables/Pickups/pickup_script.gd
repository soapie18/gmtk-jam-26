extends Node2D

@export var name_tag: String

@onready var sprite: Sprite2D = $Sprite2D
@onready var sprite_2: Sprite2D = $Sprite2D2 

@onready var audio = $AudioStreamPlayer

var default_sprite_scale: Vector2
var sprite_scale_multiplier: float = 1.1

signal item_collected(item_name_tag)


func _ready() -> void:
	default_sprite_scale = sprite.scale


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			item_collected.emit(name_tag)
			
			audio.play()
			
			#TODO make it so that theres a delay here so that audio has a chance to play
			self.queue_free()


func _on_area_2d_mouse_entered() -> void:
	sprite.scale *= sprite_scale_multiplier
	sprite_2.scale *= sprite_scale_multiplier


func _on_area_2d_mouse_exited() -> void:
	sprite.scale = default_sprite_scale
	sprite_2.scale = default_sprite_scale
