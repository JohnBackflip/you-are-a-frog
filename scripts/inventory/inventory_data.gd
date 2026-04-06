extends Resource
class_name InventoryData

signal inventory_updated(inventory_data: InventoryData)
signal inventory_interact(inventory_data: InventoryData, index: int, button: int)

@export var slot_datas: Array[SlotData]


func on_slot_clicked(index: int, button: int) -> void:
	inventory_interact.emit(self, index, button)


func add_item(data: ItemData) -> bool:
	for index in slot_datas.size():
		if slot_datas[index] == null:
			slot_datas[index] = SlotData.new()
			slot_datas[index].item_data = data
			inventory_updated.emit(self)
			return true
	print("Inventory Full!")
	return false
			


func grab_slot_data(index: int) -> SlotData:
	var slot_data = slot_datas[index]
	if slot_data:
		slot_datas[index] = null
		inventory_updated.emit(self)
		return slot_data
	else:
		return null


func drop_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	var slot_data = slot_datas[index]
	slot_datas[index] = grabbed_slot_data
	inventory_updated.emit(self)
	return slot_data
