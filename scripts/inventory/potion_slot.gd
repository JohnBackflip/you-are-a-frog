extends Slot
class_name PotionSlot

signal collect_potion


func _on_gui_input(event: InputEvent) -> void:
	# If this slot is clicked
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		collect_potion.emit()
