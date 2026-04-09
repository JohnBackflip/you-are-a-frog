extends Node

@export_dir var timeline_dir : String
@onready var potion_diary : Control = $CanvasLayer/PotionDiary
@onready var character : Node2D = $Character
var character_set: CharacterSet

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	character_set = game_manager.character_set
	character.finished_walking.connect(on_finished_walking)
	character.finished_talking.connect(on_finished_talking)
	character.initialize_char(timeline_dir)
	
	# This is just for the demo, so it's easy to show case how the characters will show
	character.walk_in(character_set.get_char(2), 0)

func on_finished_walking (timeline : String, _deadline : String):
	Dialogic.start_timeline(timeline)
	potion_diary.close_diary()

func on_finished_talking ():
	if (character): # This is me being lazy, this will be changed after the demo
		await get_tree().create_timer(3.0).timeout
		character.walk_in(character_set.get_char(1), 0)
		character=null
	potion_diary.close_diary()
