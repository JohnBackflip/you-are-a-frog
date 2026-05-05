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

func add_item(data: ItemData, quantity : int = 1) -> bool:
	var datas : Array[SlotData]
	if (data is IngredientData):
		datas = slot_datas_ingredient
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
			


func grab_slot_data(index: int, inventory : Inventory) -> SlotData:
	var slot_data : SlotData
	var slot_datas : Array[SlotData]
	if inventory is IngredientInventory:
		slot_datas = slot_datas_ingredient
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


func drop_slot_data(grabbed_slot_data: SlotData, index: int, inventory : Inventory) -> SlotData:
	var slot_data : SlotData
	var slot_datas : Array[SlotData]
	if inventory is IngredientInventory && grabbed_slot_data.item_data is IngredientData:
		slot_datas = slot_datas_ingredient
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
