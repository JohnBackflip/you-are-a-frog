extends Control

@onready var description : RichTextLabel = $Description

func set_info(slot_data : SlotData) :
	if !slot_data:
		description.text = "Seems like there isn't anything here..."
		return

	var item_data = slot_data.item_data
	if item_data is IngredientData:
		description.text =	"[b]Name: [/b]" + item_data.name + \
				"\n[b]Description: [/b]" + item_data.description + \
				"\n[b]Property: [/b]" + item_data.property.name
	elif item_data is PotionData:
		description.text =	"[b]Name: [/b]" + item_data.name + \
				"\n[b]Description: [/b]" + item_data.description 
