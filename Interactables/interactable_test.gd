extends Node2D

@onready var sprite: Sprite2D = $Sprite2D

var default_sprite_scale: Vector2
var sprite_scale_multiplier: float = 1.1

@export var item_key: String

signal item_clicked(item_key: String)


func _ready() -> void:
	default_sprite_scale = sprite.scale


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			item_clicked.emit(item_key)


func _on_area_2d_mouse_entered() -> void:
	sprite.scale *= sprite_scale_multiplier


func _on_area_2d_mouse_exited() -> void:
	sprite.scale = default_sprite_scale
