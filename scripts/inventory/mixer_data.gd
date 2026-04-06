# Mixer behaves like an inventory, with the added capability of potion crafting
extends InventoryData
class_name MixerData

signal mixer_contents(data: MixerData, ingredients: Array)


func get_ingredients() -> Array[IngredientData]:
	var ingredients = [] as Array[IngredientData]
	for slot_data in slot_datas:
		if slot_data:
			if slot_data.item_data and slot_data.item_data is IngredientData:
				ingredients.append(slot_data.item_data)
			elif slot_data.item_data and slot_data.item_data is PotionData:
				print("You can't use potions to make potions!")
	return ingredients


func on_inventory_update(_inventory_data: InventoryData) -> void:
	# Emit mixer contents on every update (for ratio calculations)
	mixer_contents.emit(self, get_ingredients())
