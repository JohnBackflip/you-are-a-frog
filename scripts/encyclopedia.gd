extends Resource
class_name Encyclopedia

@export_dir var potions_folder: String = "res://resources/potions"

var potions: Array[PotionData]


func init_potions() -> void:
	potions.clear()
	var dir = DirAccess.open(potions_folder)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			# Only load files ending in .tres or .res
			if not dir.current_is_dir() and (file_name.ends_with(".tres") or file_name.ends_with(".res")):
				var potion = load(potions_folder + "/" + file_name)
				if potion is PotionData:
					potions.append(potion)
			
			file_name = dir.get_next()
		
		print("Loaded %d potions from folder!" % potions.size())
	else:
		push_error("Could not open potion folder path: " + potions_folder)


func find_craftable_potion(ingredients: Array[IngredientData]) -> PotionData:
	# Look through each potion to see if it matches the recipe
	for potion: PotionData in potions:
		var recipe = potion.recipe
		var craftable = true
		for ingredient: IngredientData in ingredients:
			if ingredient not in recipe:
				craftable = false
		if craftable:
			return potion
	return null


func unlock_potion_recipe(potion: PotionData) -> void:
	potion.recipe_unlocked = true
