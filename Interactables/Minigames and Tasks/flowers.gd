extends Node2D

@export var flower_identifier: String

@onready var sprite = $Sprite2D
@onready var audio = $AudioStreamPlayer

#TODO change the preload for actual asset
var inbloom_texture = preload("res://Interactables/Minigames and Tasks/Minigame Items - Art/Flower_Happy.png")
var wilted_texture = preload("res://Interactables/Minigames and Tasks/Minigame Items - Art/Flower_Wilt.png")

@export var butterfly1_texture: Texture2D
@export var butterfly2_texture: Texture2D

@onready var butterfly_sprite1 = $butterfly1
@onready var butterfly_sprite2 = $butterfly2

signal flowers_watered(identifier)

func _on_button_pressed() -> void:
	print("flowers clicked")
	sprite.texture = inbloom_texture
	flowers_watered.emit(flower_identifier)
	
	audio.play()

func set_flowers_wilted() -> void:
	sprite.texture = wilted_texture

func spawn_butterflies() -> void:
	butterfly_sprite1.texture = butterfly1_texture
	butterfly_sprite2.texture = butterfly2_texture
