extends Node2D

var inventory_array: Array
@onready var player_ui = $"../PlayerUI"


func _ready() -> void:
	inventory_array.clear()
	
	player_ui.query_inventory_contents.connect(relay_inventory_contents)

func update_inventory(item_name_tag: String) -> void:
	inventory_array.append(item_name_tag)
	print(inventory_array)

# A checker function for when a minigame requires items to be in the player's
# possession in order for the minigame to trigger.
func check_for_items_in_inventory(_requested_item: String) -> void:
	pass

# Relays full contents of array to the UI so a message can be displayed there.
func relay_inventory_contents() -> void:
	player_ui.calculate_inventory_contents(inventory_array.duplicate())
