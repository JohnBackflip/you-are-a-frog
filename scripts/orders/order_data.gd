extends Resource
class_name OrderData

var customer: CharacterData
var request: String
var deadline: int
var notes: String
# Use properties for general requests, otherwise use potions for more specific requests 
var desired_potions: Array[PotionData]
var desired_properties: Array[IngredientProperty]
# Potions or properties that lead to rly bad results
var undesired_potions: Array[PotionData]
var undesired_properties: Array[IngredientProperty]


func get_customer_name() -> String:
	return customer.name
