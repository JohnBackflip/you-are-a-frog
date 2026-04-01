extends PanelContainer

signal slot_clicked(index: int, button: int)

@onready var texture_rect: TextureRect = $MarginContainer/TextureRect
@onready var quantity_label: Label = $QuantityLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func set_slot_data(slot_data: SlotData):
	texture_rect.texture = slot_data.item_data.texture
	quantity_label.text = "x%s" % str(slot_data.quantity)
	if slot_data.quantity > 1:
		quantity_label.show()
	else:
		quantity_label.hide()


func _on_gui_input(event: InputEvent) -> void:
	# If this slot is clicked
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		slot_clicked.emit(get_index(), event.button_index)
