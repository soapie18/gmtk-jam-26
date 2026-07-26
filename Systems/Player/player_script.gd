extends Node2D

@onready var inventory_system = $InventorySystem
@onready var minigame_manager = $"../MinigameManager"
@onready var scene_manager = $"../SceneManager"
@onready var day_manager = $"../DayManager"
@onready var ui = $PlayerUI

var inventory_check_result: bool

signal game_paused

func _ready() -> void:
	scene_manager.scene_inventory_changed.connect(handle_inventory_change)
	minigame_manager.minigame_inventory_query.connect(send_inventory_query)
	minigame_manager.add_loot_to_inventory.connect(request_inventory_update)
	ui.day_ended.connect(handle_day_ended)

func handle_day_ended() -> void:
	day_manager.handle_day_ended()

func handle_inventory_change(item_name_tag: String) -> void:
	inventory_system.update_inventory(item_name_tag)

func send_inventory_query(items_required: Array) -> void:
	inventory_check_result = inventory_system.check_for_items_in_inventory(items_required)
	
	if inventory_check_result:
		minigame_manager.can_start_minigame = true

func request_inventory_update(loot: String) -> void:
	inventory_system.update_inventory(loot)

func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("pause"):
		game_paused.emit()
	
	if minigame_manager.current_active_minigame == null && scene_manager.current_scene_instance != scene_manager.main_menu_instance:
		ui.visible = true
	else:
		ui.visible = false
