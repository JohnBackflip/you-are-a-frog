# Mixer behaves like an inventory, with the added capability of potion crafting
extends InventoryData
class_name MixerData

signal mixer_contents(contents: Array[SlotData], full: bool)


func is_full() -> bool:
	for slot_data in slot_datas:
		if slot_data == null:
			return false
	return true


func on_inventory_update(_inventory_data: InventoryData) -> void:
	# Emit mixer contents on every update (for ratio calculations)
	if is_full():
		mixer_contents.emit(slot_datas, true)
	else:
		mixer_contents.emit(slot_datas, false)
