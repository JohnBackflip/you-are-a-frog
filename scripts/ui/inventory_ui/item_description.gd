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
		var potion_name = "???"
		var potion_description = "???"
		var potion_ingredients = item_data.recipe
		if item_data.analysed:
			potion_name = item_data.name
			potion_description = item_data.description
		elif item_data.effect_discovered:
			potion_name = item_data.name
		description.text =	"[b]Name: [/b]" + potion_name + \
					"\n[b]Description: [/b]" + potion_description + \
					"\n[b]Ingredients: [/b]"
		for ingredient: IngredientData in potion_ingredients:
			description.text += "%s, " % str(ingredient.name)
	return true
