extends Node

@export_dir var timeline_dir : String
@onready var potion_diary : Control = $CanvasLayer/PotionDiary
@onready var character : Node2D = $Character
var character_set: CharacterSet

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	character_set = game_manager.character_set
	character.finished_walking.connect(on_finished_walking)
	character.initialize_char(timeline_dir)
	
	character.walk_in(character_set.get_char(2), "2 days", 0)

func on_finished_walking (timeline : String):
	Dialogic.start_timeline(timeline)
	potion_diary.close_diary()
