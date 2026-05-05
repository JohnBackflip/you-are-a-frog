extends TextureRect
class_name Inventory

const SLOT = preload("uid://bj32pp33u7ou4")
@onready var grid: GridContainer

func set_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_updated.connect(populate_items)
	populate_items(inventory_data)

func add_slot(inventory_data : InventoryData, index : int, slot_data : SlotData, inventory : Inventory) -> void:
		var slot = SLOT.instantiate()
		grid.add_child(slot)

		slot.slot_clicked.connect(inventory_data.on_slot_clicked)
		slot.slot_hovered.connect(inventory_data.on_slot_hovered)
		slot.slot_hover_left.connect(inventory_data.on_slot_hover_left)
		slot.index = index
		slot.parent_inventory = inventory

		if slot_data:
			slot.set_slot_data(slot_data)

func populate_items(inventory_data : InventoryData) -> void:
	pass
