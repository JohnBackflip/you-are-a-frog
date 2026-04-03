extends Inventory
class_name Mixer

@onready var craft_button: Button = %CraftButton

func check_mixer_contents(contents: Array[SlotData], full: bool) -> void:
	for slot_data: SlotData in contents:
		if slot_data:
			var item: ItemData = slot_data.item_data
			print(item.name)
	
	if full:
		craft_button.show()
	else:
		craft_button.hide()
