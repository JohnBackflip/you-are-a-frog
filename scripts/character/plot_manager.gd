extends Node2D

signal dialogue_ready
signal finished_talking

@export_dir var timeline_dir : String
@onready var potion_diary : Control = $CanvasLayer/DiaryUI
@onready var character : Node2D = $Character
@onready var order_interface : Control = $CanvasLayer/OrderInterface

var timeline : String
var timelines_dir : String

var character_set: CharacterSet
var customer_calendar : CustomerCalendar
var daily_customers : DailyCustomers

var current_character : CharacterData
var player_inventory_data: InventoryData

# Allows to give potions to characters only when they are waiting for them
var awaiting_potion : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	character_set = game_manager.character_set
	finished_talking.connect(character.on_finished_talking)
	character.finished_walking.connect(on_finished_walking)
	Dialogic.signal_event.connect(DialogicSignal)
	timelines_dir = timeline_dir
	customer_calendar = game_manager.customer_calendar

	# Initialise potion inventory
	player_inventory_data = game_manager.player_inventory_data
	order_interface.set_player_inventory_data(player_inventory_data)
	order_interface.highlight_potion_tab()

	var day = game_manager.day
	print("Day: ", day)
	daily_dialogue(day)

func daily_dialogue(day: int):
	daily_customers = customer_calendar.get_day(day)
	if daily_customers:
		for customer in daily_customers.customers:
			next_dialogue(customer)
			await dialogue_ready
		# TODO: implement randoms asw


func next_dialogue(character_data : CharacterData):
	awaiting_potion = false
	if character.character_clicked.is_connected(order_interface.give_potion):
		character.character_clicked.disconnect(order_interface.give_potion)
	
	timeline = timelines_dir + "/" + character_data.name + "_" + str(character_data.dialogue_index) + ".dtl"
	character.walk_in(character_data)
	current_character = character_data
	Dialogic.VAR.bold_color = character_data.color
	character_data.dialogue_index += 1

func on_finished_walking ():
	Dialogic.VAR.potion_given = false
	Dialogic.start_timeline(timeline)
	potion_diary.close_diary()

func DialogicSignal(arg):
	if (arg is Dictionary):
		game_events.new_order.emit(current_character, Dialogic.VAR.request, Dialogic.VAR.deadline, arg)
		finished_talking.emit()
		await get_tree().create_timer(2.0).timeout
		dialogue_ready.emit()
	elif (arg is String and arg == "leave"):
		finished_talking.emit()
		await get_tree().create_timer(2.0).timeout
		dialogue_ready.emit()
	elif (arg is String and arg == "wait_potion"):
		awaiting_potion = true
		character.character_clicked.connect(order_interface.give_potion)
		await game_events.potion_given
		Dialogic.VAR.potion_given = true
		Dialogic.start_timeline(timeline)


func _on_close_shop_button_pressed() -> void:
	var night_shop = load("uid://0yo5kafitfqt").instantiate()
	night_shop.get_node("Cauldron").modulate.a = 0
	get_parent().add_child(night_shop)
	move_to_front()
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 1.0)
	tween.tween_property(night_shop.get_node("Cauldron"), "modulate:a", 1, 0.3)
	await tween.finished
	# Reset transparency
	self_modulate.a = 1
	queue_free()
