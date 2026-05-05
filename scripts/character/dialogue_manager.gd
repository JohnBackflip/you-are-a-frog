extends Node2D

signal dialogue_ready
signal finished_talking

@onready var potion_diary : Control = $CanvasLayer/DiaryUI
@onready var character : Node2D = $Character
@onready var order_interface : Control = $CanvasLayer/OrderInterface

var plot_manager : PlotManager

var timeline : Resource

var character_set: CharacterSet
var customer_calendar : CustomerCalendar
var daily_customers : DailyCustomers

var current_character : CharacterData
var player_inventory_data: InventoryData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	character_set = game_manager.character_set
	plot_manager = game_manager.plot_manager
	finished_talking.connect(character.on_finished_talking)
	character.finished_walking.connect(on_finished_walking)
	Dialogic.signal_event.connect(DialogicSignal)
	customer_calendar = game_manager.customer_calendar

	# Initialise potion inventory
	player_inventory_data = game_manager.player_inventory_data
	order_interface.set_player_inventory_data(player_inventory_data)
	
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
	if character.character_clicked.is_connected(order_interface.give_potion):
		character.character_clicked.disconnect(order_interface.give_potion)
	
	current_character = character_data
	timeline = current_character.timeline.dialogic_timeline
	character.walk_in(character_data)
	$ShopBell.play()
	if current_character and current_character.met == false:
		current_character.met = true
	Dialogic.VAR.bold_color = character_data.color

func on_finished_walking ():
	Dialogic.VAR.potion_given = ""
	var potion_given : PotionData = current_character.timeline.potion_given
	if (potion_given):
		Dialogic.VAR.feedback = current_character.timeline.outcome[potion_given].dialogue_outcome
	Dialogic.start_timeline(timeline)
	potion_diary.close_diary()

func DialogicSignal(arg):
	var potion : PotionData = null
	match arg:
		"order":
			game_events.new_order.emit(current_character, Dialogic.VAR.request, Dialogic.VAR.deadline)
			finished_talking.emit()
			await get_tree().create_timer(1.0).timeout
			dialogue_ready.emit()
		"leave":
			finished_talking.emit()
			await get_tree().create_timer(1.0).timeout
			dialogue_ready.emit()
		"leave_done":
			finished_talking.emit()
			await get_tree().create_timer(1.0).timeout
			dialogue_ready.emit()
			return
		"wait_potion":
			character.character_clicked.connect(order_interface.give_potion)
			potion = await game_events.potion_given
			
			game_manager.order_manager.resolve_order(current_character, potion)
			
			Dialogic.VAR.potion_given = potion.name
			Dialogic.start_timeline(timeline)
	current_character.timeline = current_character.next_timeline(potion)
	

func _on_close_shop_button_pressed() -> void:
	# The game ends when there are no more days
	if (customer_calendar.customer_calendar.size() <= game_manager.day+1):
		plot_manager.go_to_ending()
		queue_free()
		return
	var night_shop = load("uid://0yo5kafitfqt").instantiate()
	night_shop.get_node("Cauldron").modulate.a = 0
	night_shop.get_node("%Mixer").modulate.a = 0
	get_parent().add_child(night_shop)
	move_to_front()
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 2.0)
	tween.tween_property(night_shop.get_node("Cauldron"), "modulate:a", 1, 0.3)
	tween.tween_property(night_shop.get_node("%Mixer"), "modulate:a", 1, 0.3)
	await tween.finished
	# Reset transparency
	self_modulate.a = 1
	queue_free()
