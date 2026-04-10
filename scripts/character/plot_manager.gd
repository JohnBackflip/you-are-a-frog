extends Node

signal dialogue_ready

@export_dir var timeline_dir : String
@onready var potion_diary : Control = $CanvasLayer/PotionDiary
@onready var character : Node2D = $Character
var character_set: CharacterSet
var customer_calendar : CustomerCalendar
var daily_customers : DailyCustomers

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	character_set = game_manager.character_set
	character.finished_walking.connect(on_finished_walking)
	character.finished_talking.connect(on_finished_talking)
	character.initialize_char(timeline_dir)
	customer_calendar = game_manager.customer_calendar
	
	# Example use
	daily_dialogue(0)
	#daily_dialogue(1)

func daily_dialogue(day: int):
	daily_customers = customer_calendar.get_day(day)
	for customer in daily_customers.customer_calendar:
		next_dialogue(character_set.get_char(customer))
		await game_events.dialogue_ready
	# TODO: implement randoms asw


func next_dialogue(character_data : CharacterData):
	character.walk_in(character_data)
	character_data.dialogue_index += 1

func on_finished_walking (timeline : String, _deadline : String):
	Dialogic.start_timeline(timeline)
	potion_diary.close_diary()

func on_finished_talking ():
	await get_tree().create_timer(3.0).timeout
	game_events.dialogue_ready.emit()
