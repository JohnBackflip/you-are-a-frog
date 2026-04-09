extends Node2D

signal finished_walking(timeline : String, deadline : String)
signal finished_talking()

@onready var step : AnimationPlayer = $CharacterStep
@onready var walk : AnimationPlayer = $CharacterWalk
@onready var leave_animation  : AnimationPlayer = $CharacterLeave
@onready var character : Sprite2D = $"Character"

var timeline : String
var timelines_dir : String

func _ready() -> void:
	Dialogic.signal_event.connect(DialogicSignal)

func initialize_char (timeline_dir : String):
	timelines_dir = timeline_dir

# Prepares a character to walk in, and "loads" the dialogue that will happen
func walk_in(character_data : CharacterData, index_timeline : int):
	step.play("RESET")
	walk.play("RESET")
	leave_animation.play("RESET")
	character.flip_h = true
	timeline = timelines_dir + "/" + character_data.name + "_" + str(index_timeline) + ".dtl"
	character.texture = character_data.art
	Dialogic.VAR.bold_color = character_data.color
	
	walk.play("character_walk")
	step.play("character_step")

func _on_character_walk_animation_finished(_anim_name):
	step.stop(true)
	character.flip_h = false
	finished_walking.emit(timeline, Dialogic.VAR.potion_deadline)

func DialogicSignal(arg : String):
	if (arg == "leave"):
		leave_animation.play("leave")
		finished_talking.emit()
