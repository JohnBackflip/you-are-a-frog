extends Resource
class_name EndingData

@export var end_name : String
@export_multiline var description_fixed : Array[String]
# If multiple potions affect the ending text this will have to be modified
var description_potion : String = ""
var points : int = 0

func get_text() -> String:
	return description_fixed[0] + description_potion + description_fixed[1]
