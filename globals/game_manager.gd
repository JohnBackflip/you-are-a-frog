extends Node

var player_inventory_data: InventoryData = preload("uid://eajge1jeea0y")
var encyclopedia: Encyclopedia = preload("uid://bysghl6lhebf4")
var mixer_data: MixerData = preload("uid://ctskj2xpfe8fy")
var character_set : CharacterSet = preload("res://resources/characters/character_set.tres")
var customer_calendar : CustomerCalendar = preload("res://resources/calendar/customer_calendar.tres")
var order_manager: OrderManager = preload("res://resources/orders/order_manager.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	encyclopedia.init_potions()
	game_events.potion_discovered.connect(encyclopedia.unlock_potion_recipe)

	order_manager.initialize()
