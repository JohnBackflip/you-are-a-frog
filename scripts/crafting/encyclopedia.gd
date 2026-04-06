extends Resource
class_name Encyclopedia

@export_dir var potions_folder: String = "res://resources/potions"

const DUD_POTION = preload("uid://dkuedc1yd8tfs")

var potions: Array[PotionData]


func init_potions():
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
					potion.set_slot_count()
					potions.append(potion)
			
			file_name = dir.get_next()
		
		print("Loaded %d potions from folder!" % potions.size())
	else:
		push_error("Could not open potion folder path: " + potions_folder)


func find_craftable_potion(ingredients: Array[IngredientData]):
	# Initialise qty of each property
	var property_count = {}
	for ingredient in ingredients:
		var property_name = ingredient.property.name
		property_count[property_name] =  property_count.get(property_name, 0) + 1
		
	# Look through each potion to see if it matches the recipe
	for potion in potions:
		var recipe = potion.recipe
		if recipe and recipe.is_match(property_count):
			return potion
	return DUD_POTION
