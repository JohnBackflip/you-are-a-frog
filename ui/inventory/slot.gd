extends PanelContainer
class_name Slot

signal slot_clicked(index: int, button: int)

@onready var texture_rect: TextureRect = $MarginContainer/TextureRect
@onready var quantity_label: Label = $QuantityLabel

var index: int


func set_slot_data(slot_data: SlotData):
	if slot_data and slot_data.item_data:
		texture_rect.texture = slot_data.item_data.art
		quantity_label.text = "x%s" % str(slot_data.quantity)
		if slot_data.quantity > 1:
			quantity_label.show()
		else:
			quantity_label.hide()
	else:
		# If set to null, reset to empty slot
		texture_rect.texture = null
		quantity_label.text = ""
		quantity_label.hide()


func _on_gui_input(event: InputEvent) -> void:
	# If this slot is clicked
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		slot_clicked.emit(index, event.button_index)
	
		
# This is only used for mixer slots for now
func on_item_consumed(slot_data: SlotData, new_quantity: int) -> void:
	if new_quantity <= 0:
		set_slot_data(null)
	else:
		set_slot_data(slot_data)
