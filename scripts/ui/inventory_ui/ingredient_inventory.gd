extends Inventory
class_name IngredientInventory

func _ready() -> void:
	grid = %IngredientGrid

func set_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_updated.connect(populate_items)
	populate_items(inventory_data)
	inventory_data.modified_slot.connect(on_modified_slot)

func open_bag(index : int):
	var slot = grid.get_child(index)
	slot.open_bag()

func close_bag(index : int):
	var slot = grid.get_child(index)
	slot.close_bag()

func on_modified_slot(index : int, slot_data : SlotData) -> void:
	var slot : IngredientSlot = grid.get_child(index)
	if slot_data:
		if !slot_data.item_consumed.is_connected(slot.on_item_consumed):
			slot_data.item_consumed.connect(slot.on_item_consumed)
	slot.set_slot_data(slot_data)

func add_slot(inventory_data : InventoryData, index : int, slot_data : SlotData, _inventory : Inventory) -> void:
	var slot = grid.get_child(index)
	if !slot.slot_clicked.is_connected(inventory_data.on_slot_clicked):
		slot.slot_clicked.connect(inventory_data.on_slot_clicked)
		slot.slot_hovered.connect(inventory_data.on_slot_hovered)
		slot.slot_hover_left.connect(inventory_data.on_slot_hover_left)
		slot.index = index
		slot.parent_inventory = self

	if slot_data:
		if !slot_data.item_consumed.is_connected(slot.on_item_consumed):
			slot_data.item_consumed.connect(slot.on_item_consumed)
		slot.add_slot_data(slot_data)

func populate_items(inventory_data: InventoryData) -> void:
	for index in inventory_data.slot_datas_ingredient.size():
		var slot_data = inventory_data.slot_datas_ingredient[index]
		add_slot(inventory_data, index, slot_data, self)
