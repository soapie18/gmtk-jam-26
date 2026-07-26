extends Node2D

@export var flower_identifier: String

@onready var sprite = $Sprite2D
@onready var audio = $AudioStreamPlayer

#TODO change the preload for actual asset
var inbloom_texture = preload("res://Interactables/Minigames and Tasks/Minigame Items - Art/Spider_Decend.png")

signal flowers_watered(identifier)

func _on_button_pressed() -> void:
	print("flowers clicked")
	sprite.texture = inbloom_texture
	flowers_watered.emit(flower_identifier)
	
	audio.play()
