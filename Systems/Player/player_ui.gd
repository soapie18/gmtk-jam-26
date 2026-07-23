extends CanvasLayer

@onready var inventory_icon = $InventoryView
@onready var inventory_system = $"../InventorySystem"

var contents_sentence: String

signal query_inventory_contents


func _on_inventory_view_pressed() -> void:
	query_inventory_contents.emit()
	
	display_inventory_contents()

func calculate_inventory_contents(array: Array) -> void:
	
	contents_sentence = "In your bag you see"
	
	if array == null:
		contents_sentence += "- oh, nothing just yet."
	else:
		contents_sentence = "In your bag you see"
		for item in array:
			match item:
				"feather":
					contents_sentence += " some feathers.."
				"twig":
					contents_sentence += " some twigs.."
				"monarch caterpillar":
					contents_sentence += " some caterpillars.."
				"moth caterpillar":
					contents_sentence += " some larvae.."
				"apple":
					contents_sentence += " some apples.."
				_:
					continue

func display_inventory_contents() -> void:
	print(contents_sentence)
