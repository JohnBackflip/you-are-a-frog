extends ItemData
class_name PotionData

@export var recipe: Recipe

var slots_taken: int

func set_slot_count() -> void:
	var count = 0
	if recipe:
		for step in recipe.recipe_steps:
			count += step.quantity
		slots_taken = count
	else:
		slots_taken = 1
