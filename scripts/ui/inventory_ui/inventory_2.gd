extends TextureRect
class_name Inventory2

const SLOT = preload("uid://bj32pp33u7ou4")

@onready var ingredient_grid: GridContainer = %IngredientGrid
@onready var potion_grid: GridContainer = %PotionGrid


func set_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_updated.connect(populate_ingredients)
	populate_ingredients(inventory_data)


func populate_ingredients(inventory_data: InventoryData) -> void:
	# Clear previous / placeholder items
	for item in ingredient_grid.get_children():
		item.queue_free()
		
	for index in inventory_data.slot_datas.size():
		var slot_data = inventory_data.slot_datas[index]
		var slot = SLOT.instantiate()
		ingredient_grid.add_child(slot)
		
		slot.slot_clicked.connect(inventory_data.on_slot_clicked)
		slot.index = index
		
		if slot_data:
			slot.set_slot_data(slot_data)
