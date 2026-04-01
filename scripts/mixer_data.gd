# Mixer behaves like an inventory, with the added capability of potion crafting
extends InventoryData
class_name MixerData

signal is_mixer_full(full: bool)

func is_full() -> bool:
	for slot_data in slot_datas:
		if slot_data == null:
			return false
	return true


func on_inventory_update(_inventory_data: InventoryData) -> void:
	# Checks if mixer is full whenever an item is added / removed
	if is_full():
		print("Mixer full!")
		is_mixer_full.emit(true)
	else:
		is_mixer_full.emit(false)
