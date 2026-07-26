extends CharacterBody2D

signal finished_task(success: bool)

@export var dmg = 100
@onready var PidgeonNest: CharacterBody2D   = %PidgeonNest
@onready var ConfettiBurst: GPUParticles2D   = %ConfettiBurst
@onready var WinLabel: Label   = %WinLabel
@onready var Skillcheck: Node2D   = %QuickTimeEventbar
@onready var win_sound: AudioStreamPlayer = %WinSound
@onready var repair_sound: AudioStreamPlayer = %RepairSound


func _process(delta: float) -> void:
	$hp.value = dmg

func _ready() -> void:
	$AnimatedSprite2D.play("idle")

func heal():
	dmg -= 20
	ConfettiBurst.emitting = true
	repair_sound.play()

func success():
	if dmg <= 0.0:
		ConfettiBurst.emitting = true
		$AnimatedSprite2D.play("Fixed")
		WinLabel.show()
		Skillcheck.hide()  
		win_sound.play()
		await get_tree().create_timer(2).timeout
		finished_task.emit(true)
