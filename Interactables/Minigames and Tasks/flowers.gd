extends Node2D

@export var flower_identifier: String

@onready var sprite = $Sprite2D
#TODO change the preload for actual asset
var inbloom_texture = preload("res://Interactables/Minigames and Tasks/Minigame Items - Art/Spider_Decend.png")

var watered: bool = false

signal flowers_watered(identifier)

func _on_button_pressed() -> void:
	print("flowers clicked")
	sprite.texture = inbloom_texture
	flowers_watered.emit(flower_identifier)
	
	watered = true
