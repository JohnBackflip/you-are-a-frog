extends Resource
class_name InventoryData

signal inventory_updated(inventory_data: InventoryData)
signal inventory_interact(inventory : Inventory, inventory_data: InventoryData, index: int, button: int)
signal inventory_show_tooltip(inventory_data: InventoryData, index: int, inventory : Inventory)
signal inventory_hide_tooltip()

@export var slot_datas_potion: Array[SlotData]
@export var slot_datas_ingredient: Array[SlotData]

func on_slot_clicked(index: int, button: int, inventory : Inventory) -> void:
	inventory_interact.emit(inventory, self, index, button)

func on_slot_hovered(index: int, inventory : Inventory) -> void:
	inventory_show_tooltip.emit(self, index, inventory)

func on_slot_hover_left() -> void:
	inventory_hide_tooltip.emit()

func consume_item(slots : Array[SlotData], index : int) -> void:
	slots[index].consume_item()
	if (slots[index].quantity <= 0):
		slots[index] = null

# Put all the ingredients of the same kind in just one bag
func rearange_ingredients() -> void:
	var visited_ingredients : Dictionary[String, int]
	for index in slot_datas_ingredient.size():
		if slot_datas_ingredient[index] and slot_datas_ingredient[index].item_data.name in visited_ingredients:
			while slot_datas_ingredient[index] and slot_datas_ingredient[index].quantity > 0:
				slot_datas_ingredient[visited_ingredients.get(slot_datas_ingredient[index].item_data.name)].add_item()
				consume_item(slot_datas_ingredient, index)
			slot_datas_ingredient[index] = null
		elif slot_datas_ingredient[index]:
			visited_ingredients.set(slot_datas_ingredient[index].item_data.name, index)
		inventory_updated.emit(self)

# Put the ingredients back into the inventory
func store_ingredient(data : ItemData, quantity : int = 1) -> bool:
	# Place on same slot as others
	for index in slot_datas_ingredient.size():
		if slot_datas_ingredient[index] and slot_datas_ingredient[index].item_data == data:
			slot_datas_ingredient[index].add_item()
			inventory_updated.emit(self)
			return true

	# If item last of its kind, find an empty slot
	for index in slot_datas_ingredient.size():
		if slot_datas_ingredient[index] == null:
			slot_datas_ingredient[index] = SlotData.new()
			slot_datas_ingredient[index].item_data = data
			slot_datas_ingredient[index].set_quantity(quantity)
			inventory_updated.emit(self)
			return true
	print("Inventory Full!")
	return false


func add_item(data: ItemData, quantity : int = 1) -> bool:
	var datas : Array[SlotData]
	if (data is IngredientData):
		return store_ingredient(data, quantity)
	elif (data is PotionData):
		datas = slot_datas_potion

	for index in datas.size():
		if datas[index] == null:
			datas[index] = SlotData.new()
			datas[index].item_data = data
			datas[index].set_quantity(quantity)
			inventory_updated.emit(self)
			return true
	print("Inventory Full!")
	return false
			

# Ingredients are stored in bags. Removing an ingredient only gets one out
func grab_ingredient(index : int) -> SlotData:
	if (!slot_datas_ingredient[index]):
		return null
	if slot_datas_ingredient[index]:
		var slot_data = slot_datas_ingredient[index].duplicate(true)
		consume_item(slot_datas_ingredient, index)
		slot_data.set_quantity(1)
		inventory_updated.emit(self)
		return slot_data
	else:
		return null

func grab_slot_data(index: int, inventory : Inventory) -> SlotData:
	var slot_data : SlotData
	var slot_datas : Array[SlotData]
	if inventory is IngredientInventory:
		return grab_ingredient(index)
	elif inventory is PotionInventory:
		slot_datas = slot_datas_potion
	elif inventory is MixerInventory:
		slot_datas = slot_datas_ingredient

	slot_data = slot_datas[index]
	if slot_data:
		slot_datas[index] = null
		inventory_updated.emit(self)
		return slot_data
	else:
		return null

func drop_ingredient(grabbed_slot_data: SlotData, index: int) -> SlotData:
	var slot_data : SlotData

	slot_data = slot_datas_ingredient[index]
	if !slot_data:
		slot_data = slot_datas_ingredient[index]
		slot_datas_ingredient[index] = grabbed_slot_data
	elif slot_data.item_data != grabbed_slot_data.item_data:
		return grabbed_slot_data
	else:
		slot_datas_ingredient[index].add_item()
		slot_data = null

	inventory_updated.emit(self)
	return slot_data

func drop_slot_data(grabbed_slot_data: SlotData, index: int, inventory : Inventory) -> SlotData:
	var slot_data : SlotData
	var slot_datas : Array[SlotData]
	if inventory is IngredientInventory && grabbed_slot_data.item_data is IngredientData:
		return drop_ingredient(grabbed_slot_data, index)
	elif inventory is PotionInventory && grabbed_slot_data.item_data is PotionData:
		slot_datas = slot_datas_potion
	elif inventory is MixerInventory && grabbed_slot_data.item_data is IngredientData:
		slot_datas = slot_datas_ingredient
	else:
		return grabbed_slot_data

	slot_data = slot_datas[index]
	slot_datas[index] = grabbed_slot_data

	inventory_updated.emit(self)
	return slot_data
