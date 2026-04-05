extends Resource
class_name SlotData

const MAX_STACK_SIZE: int = 99

@export var item_data: ItemData
@export_range(1, MAX_STACK_SIZE) var quantity: int = 1: set = set_quantity


func set_quantity(value: int) -> void:
	if value > 1 and item_data.stackable == false:
		quantity = 1
		push_error("Item %s is not stackable, please set it to stackable first." % item_data.name) 
	else:
		quantity = value
