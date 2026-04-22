extends Resource
class_name InventoryData

signal inventory_updated(inventory_data: InventoryData)
signal inventory_interact(inventory_data: InventoryData, index: int, button: int)
signal inventory_show_tooltip(inventory_data: InventoryData, index: int, pos : int)
signal inventory_hide_tooltip()

@export var slot_datas_potion: Array[SlotData]
@export var slot_datas_ingredient: Array[SlotData]

func on_slot_clicked(index: int, button: int) -> void:
	inventory_interact.emit(self, index, button)

func on_slot_hovered(index: int, pos : Vector2) -> void:
	inventory_show_tooltip.emit(self, index, pos)

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
			


func grab_slot_data(index: int, current_tab : game_manager.InventoryTab) -> SlotData:
	var slot_data : SlotData
	if current_tab == game_manager.InventoryTab.INGREDIENT:
		slot_data = slot_datas_ingredient[index]
	elif current_tab == game_manager.InventoryTab.POTION:
		slot_data = slot_datas_potion[index]

	if slot_data:
		if current_tab == game_manager.InventoryTab.INGREDIENT:
			slot_datas_ingredient[index] = null
		elif current_tab == game_manager.InventoryTab.POTION:
			slot_datas_potion[index] = null
		inventory_updated.emit(self)
		return slot_data
	else:
		return null


func drop_slot_data(grabbed_slot_data: SlotData, index: int, current_tab : game_manager.InventoryTab) -> SlotData:
	var slot_data : SlotData
	if current_tab == game_manager.InventoryTab.INGREDIENT && grabbed_slot_data.item_data is IngredientData:
		slot_data = slot_datas_ingredient[index]
		slot_datas_ingredient[index] = grabbed_slot_data
	elif current_tab == game_manager.InventoryTab.POTION && grabbed_slot_data.item_data is PotionData:
		slot_data = slot_datas_potion[index]
		slot_datas_potion[index] = grabbed_slot_data
	else:
		return grabbed_slot_data

	inventory_updated.emit(self)
	return slot_data
