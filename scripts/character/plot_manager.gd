extends Node

signal dialogue_ready
signal finished_talking

@export_dir var timeline_dir : String
@onready var potion_diary : Control = $CanvasLayer/PotionDiary
@onready var character : Node2D = $Character

var timeline : String
var timelines_dir : String

var character_set: CharacterSet
var customer_calendar : CustomerCalendar
var daily_customers : DailyCustomers

var current_character : CharacterData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	character_set = game_manager.character_set
	finished_talking.connect(character.on_finished_talking)
	character.finished_walking.connect(on_finished_walking)
	Dialogic.signal_event.connect(DialogicSignal)
	timelines_dir = timeline_dir
	customer_calendar = game_manager.customer_calendar
	
	# Example use
	daily_dialogue(0)
	#daily_dialogue(1)

func daily_dialogue(day: int):
	daily_customers = customer_calendar.get_day(day)
	for customer in daily_customers.customers:
		next_dialogue(customer)
		await dialogue_ready
	# TODO: implement randoms asw


func next_dialogue(character_data : CharacterData):
	timeline = timelines_dir + "/" + character_data.name + "_" + str(character_data.dialogue_index) + ".dtl"
	character.walk_in(character_data)
	current_character = character_data
	Dialogic.VAR.bold_color = character_data.color
	character_data.dialogue_index += 1

func on_finished_walking ():
	Dialogic.start_timeline(timeline)
	potion_diary.close_diary()

func DialogicSignal(arg):
	if (arg is Dictionary):
		game_events.new_order.emit(current_character, Dialogic.VAR.request, Dialogic.VAR.deadline, arg)
		finished_talking.emit()
		await get_tree().create_timer(2.0).timeout
		dialogue_ready.emit()
