extends Control

@onready var description : RichTextLabel = $Description

func set_info(slot_data : SlotData) -> bool:
	if !slot_data:
		return false

	var item_data = slot_data.item_data
	if item_data is IngredientData:
		description.text =	"[b]Name: [/b]" + item_data.name + \
				"\n[b]Description: [/b]" + item_data.description
	elif item_data is PotionData:
		if item_data.analysed:
			description.text =	"[b]Name: [/b]" + item_data.name + \
					"\n[b]Description: [/b]" + item_data.description 
		elif item_data.effect_discovered:
			description.text =	"[b]Name: [/b]" + item_data.name + \
					"\n[b]Description: [/b]" + "???" 
		else:
			description.text =	"[b]Name: [/b]" + "???" + \
					"\n[b]Description: [/b]" + "???"
	return true
