extends CanvasLayer

signal leave_requested

func _on_button_pressed() -> void:
	leave_requested.emit()
