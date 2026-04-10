extends Node

var encyclopedia: Encyclopedia = preload("res://resources/encyclopedia.tres")
var player_inventory_data: InventoryData = preload("res://resources/demo_inventory.tres")
var mixer_data: MixerData = preload("res://resources/mixer_data.tres")
var character_set : CharacterSet = preload("res://resources/characters/character_set.tres")
var customer_calendar : CustomerCalendar = preload("res://resources/calendar/customer_calendar.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	encyclopedia.init_potions()
	game_events.potion_discovered.connect(encyclopedia.unlock_potion_recipe)
