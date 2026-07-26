extends Node2D

@onready var pointer: Sprite2D = $pointer
@onready var pos_1: Marker2D = $pos1
@onready var pos_2: Marker2D = $pos2
@onready var PidgeonNest: CharacterBody2D = $"../PidgeonNest"
@onready var safezone_pos_1: Marker2D = $safezone_pos1
@onready var safezone_pos_2: Marker2D = $safezone_pos2



var direction = 1 
var keydown = false

func _process(delta: float) -> void:
	
	if pointer.position.x <= pos_1.position.x:
		direction = 1
	elif pointer.position.x >= pos_2.position.x:
		direction = -1
	
	pointer.position.x += direction
	
	if Input.is_action_pressed("fix nest"):
		if pointer.position.x >= safezone_pos_1.position.x and pointer.position.x <= safezone_pos_2.position.x:
			PidgeonNest.heal()
			if PidgeonNest.dmg <= 0.0:
				PidgeonNest.success()
		
