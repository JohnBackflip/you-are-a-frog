extends TextureRect
class_name Inventory

const SLOT = preload("uid://bj32pp33u7ou4")

@onready var ingredient_grid: GridContainer = %IngredientGrid
@onready var potion_grid: GridContainer = %PotionGrid

@onready var potions_tab : MarginContainer = $TabContainer/Potions

var current_tab : int = game_manager.InventoryTab.INGREDIENT

func highlight_potion_tab():
	potions_tab.visible = true

func set_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_updated.connect(populate_items)
	populate_items(inventory_data)

# Right now there are the same number of slots for ingredients and potions
func populate_items(inventory_data: InventoryData) -> void:
	# Clear previous / placeholder items
	for item in ingredient_grid.get_children():
		item.queue_free()
	for item in potion_grid.get_children():
		item.queue_free()
		
	for index in inventory_data.slot_datas_ingredient.size():
		var slot_data = inventory_data.slot_datas_ingredient[index]
		add_slot(inventory_data, index, slot_data, ingredient_grid)

	for index in inventory_data.slot_datas_potion.size():
		var slot_data = inventory_data.slot_datas_potion[index]
		add_slot(inventory_data, index, slot_data, potion_grid)

func add_slot(inventory_data : InventoryData, index : int, slot_data : SlotData, grid : GridContainer) -> void:
		var slot = SLOT.instantiate()
		grid.add_child(slot)

		slot.slot_clicked.connect(inventory_data.on_slot_clicked)
		slot.slot_hovered.connect(inventory_data.on_slot_hovered)
		slot.slot_hover_left.connect(inventory_data.on_slot_hover_left)
		slot.index = index
		
		if slot_data:
			slot.set_slot_data(slot_data)


func _on_tab_container_tab_changed(tab: int) -> void:
	current_tab = tab
