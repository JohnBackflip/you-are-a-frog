extends Inventory
class_name Mixer

@onready var craft_button: Button = %CraftButton

func _ready() -> void:
	# Remove the "description" on the mixer
	$VBoxContainer/ItemDescription.queue_free()

signal ingredients_updated(ingredients: Array[ItemData])

func check_mixer_contents(contents: Array[SlotData], full: bool) -> void:
	var ingredients: Array[ItemData] = []
	for slot_data: SlotData in contents:
		if slot_data:
			var item: ItemData = slot_data.item_data
			ingredients.append(item)
	ingredients_updated.emit(ingredients)
	
	if full:
		craft_button.show()
	else:
		craft_button.hide()
