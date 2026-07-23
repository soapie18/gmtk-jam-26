extends Node2D

@export var name_tag: String

@onready var sprite: Sprite2D = $Sprite2D

var default_sprite_scale: Vector2
var sprite_scale_multiplier: float = 1.1

@export var isCollected: bool

signal item_collected(item_name_tag)


func _ready() -> void:
	default_sprite_scale = sprite.scale


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			item_collected.emit(name_tag)
			
			self.queue_free()


func _on_area_2d_mouse_entered() -> void:
	sprite.scale *= sprite_scale_multiplier


func _on_area_2d_mouse_exited() -> void:
	sprite.scale = default_sprite_scale
