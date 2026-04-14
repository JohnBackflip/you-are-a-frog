extends Node2D

signal finished_walking()

@onready var step : AnimationPlayer = $CharacterStep
@onready var walk : AnimationPlayer = $CharacterWalk
@onready var leave_animation  : AnimationPlayer = $CharacterLeave
@onready var character : Sprite2D = $"Character"

# Prepares a character to walk in, and "loads" the dialogue that will happen
func walk_in(character_data : CharacterData):
	step.play("RESET")
	walk.play("RESET")
	leave_animation.play("RESET")
	character.texture = character_data.art
	
	walk.play("character_walk")
	step.play("character_step")

func _on_character_walk_animation_finished(_anim_name):
	step.stop(true)
	finished_walking.emit()

func on_finished_talking ():
	leave_animation.play("leave")
