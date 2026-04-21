extends TextureButton

signal order_selected(order: OrderData)

@onready var name_label: Label = $NameLabel

var order_data: OrderData


func set_order_data(order: OrderData) -> void:
	order_data = order
	set_customer_name(order_data.get_customer_name())


func set_customer_name(customer_name: String) -> void:
	name_label.text = customer_name


func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		order_selected.emit(order_data)
		self_modulate = Color("969696")
	else:
		self_modulate = Color("ffffff")
