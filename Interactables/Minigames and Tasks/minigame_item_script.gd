extends Node2D

@export var minigame_tag: String

@onready var sprite = $Sprite2D
@onready var audio = $AudioStreamPlayer

var on_cooldown: bool = false
var cooldown_time: float = 2

signal minigame_requested(mingame_name_tag: String)

func _ready() -> void:
	pass 



func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if !on_cooldown:
				on_cooldown = true
				# Connected to in scene the minigame belongs in, e.g grass scene.
				audio.play()
				await get_tree().create_timer(0.6).timeout
				minigame_requested.emit(minigame_tag)
				
				get_tree().create_timer(cooldown_time).timeout.connect(func(): on_cooldown = false)
			
