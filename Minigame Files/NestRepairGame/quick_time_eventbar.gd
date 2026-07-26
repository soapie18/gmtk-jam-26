extends Node2D

@onready var background: Sprite2D = $background
@onready var pointer: Sprite2D = $pointer
@onready var start: Marker2D = $start
@onready var end: Marker2D = $end
@onready var safestartpos: Marker2D = $safestartpos
@onready var safeendpos: Marker2D = $safeendpos
@onready var PidgeonNest: CharacterBody2D = $"../PidgeonNest"

var direction = 1 #right 


func _process(delta: float) -> void:
	
	if pointer.position.x <= start.position.x:
		direction = 1
	elif pointer.position.x >= end.position.x:
		direction = -1
		
	pointer.position.x += direction
	
	if Input.is_action_just_pressed("fix nest"):
		if pointer.position.x >= safestartpos.position.x and pointer.position.x <= safeendpos.position.x:
			PidgeonNest.heal()
	
