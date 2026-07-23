extends Node2D

@onready var inventory_system = $InventorySystem
@onready var scene_manager = $"../SceneManager"

func _ready() -> void:
	scene_manager.scene_inventory_changed.connect(handle_inventory_change)

func handle_inventory_change(item_name_tag: String) -> void:
	inventory_system.update_inventory(item_name_tag)
