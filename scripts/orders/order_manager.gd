extends Resource
class_name OrderManager

@export_dir var potions_folder: String = "res://resources/potions"

var orders : Array[OrderData]

var potions : Dictionary


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
	init_potions()

# Gets called when the order is placed, prepares the order
func on_new_order  (customer: CharacterData, request: String, deadline: int) -> void:
	var order : OrderData  = OrderData.new()
	order.customer = customer
	order.request = request
	order.deadline = deadline
	orders.append(order)
	print(order.get_customer_name(), order.deadline, order.request)

func resolve_order (customer : CharacterData, potion_given : PotionData) -> void:
	print("Potion " + potion_given.name + " given to " + customer.name)
	var order : OrderData
	for order_data in orders:
		if (order_data.customer == customer):
			order = order_data
			break
	orders.erase(order)
	var outcome_points : Array[EndingPoints] = customer.timeline.outcome[potion_given].endings
	for ending_points in outcome_points:
		game_manager.plot_manager.endings[ending_points.ending] += ending_points.points
		if (ending_points.ending_text != ""):
			ending_points.ending.description_potion = ending_points.ending_text
	customer.potion_given = potion_given
