extends Node2D

var inventory_array: Array
@onready var player_ui = $"../PlayerUI"


func _ready() -> void:
	inventory_array.resize(0)
	
	player_ui.query_inventory_contents.connect(relay_inventory_contents_ui)

func update_inventory(item_name: String) -> void:
	inventory_array.append(item_name)
	print(inventory_array)

# A checker function for when a minigame or task requires items to be in the 
# player's possession in order for the minigame to trigger.
func check_for_items_in_inventory(items_required: Array) -> bool:
	var items_count = items_required.size()
	
	if items_count == 0:
		return true
	
	var match_count: int = 0
	
	for item in items_required:
		for inventory_member in inventory_array:
			if inventory_member == item:
				match_count += 1
	
	if match_count == items_count:
		print(items_count)
		print(match_count)
		return true
	else:
		return false

# Relays full contents of array to the UI so a message can be displayed there.
func relay_inventory_contents_ui() -> void:
	player_ui.calculate_inventory_contents(inventory_array.duplicate())
