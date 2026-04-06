extends Resource
class_name CharacterSet

@export var characters : Array[CharacterData]

func get_char(index : int):
	return characters[index]
