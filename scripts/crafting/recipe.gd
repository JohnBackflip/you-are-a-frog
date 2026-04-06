extends Resource
class_name Recipe

@export var recipe_steps: Array[RecipeStep]


func is_match(property_count: Dictionary) -> bool:
	# If the mixer has more/fewer types of properties than the recipe, you might want to handle that logic here.
	
	for step in recipe_steps:
		var required_amount = step.quantity
		var available_amount = property_count.get(step.property.name, 0)
		
		if available_amount < required_amount:
			return false # Early exit: missing an ingredient
			
	return true
	
