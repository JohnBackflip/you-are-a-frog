extends Node2D

@onready var step : AnimationPlayer = $CharacterStep
@onready var walk : AnimationPlayer = $CharacterWalk
@onready var leave_animation  : AnimationPlayer = $CharacterLeave
@onready var character : Sprite2D = $"Character"

var deadline : String
var timeline : String
var timelines_dir : String

func _ready() -> void:
	Dialogic.signal_event.connect(DialogicSignal)

func initialize_char (timeline_dir : String):
	timelines_dir = timeline_dir

# Prepares a character to walk in, and "loads" the dialogue that will happen
func walk_in(character_data : CharacterData, deadline_str : String, index_timeline : int):
	character.self_modulate = "ffffff" # The character disappears, have to reset the transparency when they're back
	deadline = deadline_str
	timeline = timelines_dir + "/" + character_data.name + "_" + str(index_timeline) + ".dtl"
	character.texture = character_data.art
	walk.play("character_walk")
	step.play("character_step")

func _on_character_walk_animation_finished(_anim_name):
	step.stop(true)
	Dialogic.VAR.potion_deadline = deadline
	Dialogic.start_timeline(timeline)

func DialogicSignal(arg : String):
	if (arg == "leave"):
		leave_animation.play("leave")
