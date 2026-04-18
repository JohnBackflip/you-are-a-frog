extends ItemData
class_name PotionData

@export var recipe: Recipe
@export var primary_property: IngredientProperty

var slots_taken: int
var recipe_unlocked: bool = false #This unlocks recipe and potion image
var effect_discovered: bool = false #This unlocks the actual potion name, set this to true after customer feedback
var analysed: bool = false #This unlocks description, set this to true after guild analysis


func set_slot_count() -> void:
	var count = 0
	if recipe:
		for step in recipe.recipe_steps:
			count += step.quantity
		slots_taken = count
	else:
		slots_taken = 1
