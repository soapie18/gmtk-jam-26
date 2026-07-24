extends CanvasLayer

@onready var inventory_icon = $InventoryView
@onready var inventory_system = $"../InventorySystem"
@onready var text = $Label
@onready var text_timer = $TextCooldown

var contents_sentence: String
var default_text: String
var text_cooled_down: bool = true

signal query_inventory_contents

func _ready() -> void:
	default_text = text.text
	text_timer.timeout.connect(reset_text)


func _on_inventory_view_pressed() -> void:
	if text_cooled_down:
		query_inventory_contents.emit()
		display_inventory_contents()

func calculate_inventory_contents(array: Array) -> void:
	
	contents_sentence = "In your bag you see- oh, nothing just yet."
	
	if array.size() == 0:
		return
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
				"fish":
					contents_sentence += " some fish.."
				_:
					continue

func display_inventory_contents() -> void:
	text_cooled_down = false
	text.text = contents_sentence
	
	text_timer.start()
	text_timer.wait_time = 3

func reset_text() -> void:
	text.text = default_text
	text_cooled_down = true
	
