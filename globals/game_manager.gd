extends Node

var encyclopedia: Encyclopedia = preload("res://resources/encyclopedia.tres")
var player_inventory_data: InventoryData = preload("res://resources/demo_inventory.tres")
var mixer_data: MixerData = preload("res://resources/mixer_data.tres") 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	encyclopedia.init_potions