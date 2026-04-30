extends Resource
class_name OrderManager

@export_dir var properties_folder: String = "res://resources/ingredient_properties"
@export_dir var potions_folder: String = "res://resources/potions"

var orders : Array[OrderData]

var properties : Dictionary
var potions : Dictionary

func init_properties() -> void:
	properties.clear()
	var dir = DirAccess.open(properties_folder)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			# Only load files ending in .tres or .res
			if not dir.current_is_dir() and (file_name.ends_with(".tres") or file_name.ends_with(".res")):
				var property = load(properties_folder + "/" + file_name)
				if property is IngredientProperty:
					properties.set(file_name.get_slice(".tres", 0), property)
			
			file_name = dir.get_next()
		
		print("Loaded %d properties from folder!" % properties.size())
	else:
		push_error("Could not open properties folder path: " + properties_folder)

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
					potions.set(file_name.get_slice("_potion.tres", 0), potion)
			
			file_name = dir.get_next()
		
		print("Loaded %d potions from folder!" % potions.size())
	else:
		push_error("Could not open potions folder path: " + potions_folder)

func initialize() -> void:
	game_events.new_order.connect(on_new_order)
	# Create dictionaries for properties and potions
	init_properties()
	init_potions()

func decipher_desired(desired_undesired : Dictionary) -> Dictionary:
	var desired_potions    : Array[PotionData]
	var undesired_potions  : Array[PotionData]
	var desired_properties : Array[IngredientProperty]
	var undesired_properties : Array[IngredientProperty]
	
	var result : Dictionary = { "desired_potions" = desired_potions,
								"undesired_potions" = undesired_potions,
								"desired_properties" = desired_properties,
								"undesired_properties" = undesired_properties}
	for req in desired_undesired.keys():
		var property_potion = desired_undesired.get(req)
		if req.contains("property"):
			if (!properties.has(property_potion)):
				push_error("Property " + property_potion + " not in dictionary")
			if req.contains("undesired"):
				result.undesired_properties.append(properties.get(property_potion))
			else:
				result.desired_properties.append(properties.get(property_potion))
		elif req.contains("potion"):
			if (!potions.has(property_potion)):
				push_error("Potion " + property_potion + " not in dictionary")
			if req.contains("undesired"):
				result.undesired_potions.append(potions.get(property_potion))
			else:
				result.desired_potions.append(potions.get(property_potion))
		else:
			push_error("Wrongly formulated (un)desired property/potion")
	return result

# Gets called when the order is placed, prepares the order
func on_new_order  (customer: CharacterData, request: String, deadline: int, desired_undesired : Dictionary):
	var order : OrderData  = OrderData.new()
	order.customer = customer
	order.request = request
	order.deadline = deadline
	var dechiphered : Dictionary = decipher_desired(desired_undesired)
	order.desired_potions = dechiphered.desired_potions
	order.desired_properties = dechiphered.desired_properties
	order.undesired_potions = dechiphered.undesired_potions
	order.undesired_properties = dechiphered.undesired_properties
	orders.append(order)
	print(order.get_customer_name(), order.deadline, order.request, order.desired_potions, order.undesired_potions)
