extends Control

@onready var orders: VBoxContainer = $Orders
@onready var customer_portrait: TextureRect = $CustomerPortrait
@onready var customer_request: Label = $CustomerRequest
@onready var notes: TextEdit = $Notes

const ORDER_ENTRY = preload("uid://c2k6hxybbd20p")

var order_datas: Array[OrderData]
var current_order: OrderData
var order_btn_group = ButtonGroup.new()

func _ready() -> void:
	update_orders()
	hide_data()


func update_orders() -> void:
	for order in orders.get_children():
		order.queue_free()
		
	if game_manager.order_manager.orders:
		order_datas = game_manager.order_manager.orders
		for order_data: OrderData in order_datas:
			var entry = ORDER_ENTRY.instantiate()
			orders.add_child(entry)
			entry.set_order_data(order_data)
			entry.order_selected.connect(on_order_selected)
			entry.button_group = order_btn_group


func populate_data(order: OrderData) -> void:
	if order:
		# Set customer portrait
		customer_portrait.texture = order.customer.icon
		# Set customer request
		customer_request.text = order.request
		# Set order notes
		notes.text = order.notes
		show_data()


func on_order_selected(order: OrderData) -> void:
	current_order = order
	populate_data(current_order)


func _on_notes_text_changed() -> void:
	current_order.notes = notes.text


func hide_data() -> void:
	customer_portrait.hide()
	customer_request.hide()
	notes.hide()
	
func show_data() -> void:
	customer_portrait.show()
	customer_request.show()
	notes.show()
