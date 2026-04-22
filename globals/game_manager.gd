extends Node

# Scene-related
const LOADING_SCREEN_PATH = "res://scenes/loading_screen.tscn"
const DAY_SHOP_PATH = "res://scenes/shop/day_shop.tscn"
const NIGHT_SHOP_PATH = "res://scenes/shop/night_shop.tscn"

var target_scene_path: String

# Data-related
var player_inventory_data: InventoryData = preload("uid://eajge1jeea0y")
var encyclopedia: Encyclopedia = preload("uid://bysghl6lhebf4")
var mixer_data: MixerData = preload("uid://ctskj2xpfe8fy")
var character_set : CharacterSet = preload("res://resources/characters/character_set.tres")
var customer_calendar : CustomerCalendar = preload("res://resources/calendar/customer_calendar.tres")
var order_manager: OrderManager = preload("res://resources/orders/order_manager.tres")

enum Period {DAY, NIGHT}

var day: int = 0 #Set to 0 for index usage
var period: Period = Period.DAY


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	encyclopedia.init_potions()
	game_events.potion_discovered.connect(encyclopedia.unlock_potion_recipe)

	order_manager.initialize()


func load_scene(path: String):
	target_scene_path = path
	var loading_screen = load(LOADING_SCREEN_PATH)
	get_tree().change_scene_to_packed(loading_screen)
