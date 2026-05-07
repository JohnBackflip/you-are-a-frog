extends Inventory
class_name IngredientInventory

func _ready() -> void:
	grid = %IngredientGrid

func add_slot(inventory_data : InventoryData, index : int, slot_data : SlotData, _inventory : Inventory) -> void:
		super(inventory_data, index, slot_data, self)

func populate_items(inventory_data: InventoryData) -> void:
	# Clear previous / placeholder items
	for item in grid.get_children():
		item.queue_free()
		
	for index in inventory_data.slot_datas_ingredient.size():
		var slot_data = inventory_data.slot_datas_ingredient[index]
		add_slot(inventory_data, index, slot_data, self)
