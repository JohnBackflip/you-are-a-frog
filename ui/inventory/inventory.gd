extends PanelContainer
class_name Inventory

const SLOT = preload("uid://bj32pp33u7ou4")

@onready var item_grid: GridContainer = $MarginContainer/ItemGrid


func set_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_updated.connect(populate_item_grid)
	populate_item_grid(inventory_data)


func populate_item_grid(inventory_data: InventoryData) -> void:
	# Clear previous / placeholder items
	for item in item_grid.get_children():
		item.queue_free()
		
	for slot_data in inventory_data.slot_datas:
		var slot = SLOT.instantiate()
		item_grid.add_child(slot)
		
		slot.slot_clicked.connect(inventory_data.on_slot_clicked)
		
		if slot_data:
			slot.set_slot_data(slot_data)
		
