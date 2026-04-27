extends Node2D

signal finished_walking()
signal character_clicked()

@onready var step : AnimationPlayer = $CharacterStep
@onready var walk : AnimationPlayer = $CharacterWalk
@onready var leave_animation  : AnimationPlayer = $CharacterLeave
@onready var character : Sprite2D = $"Character"

# Prepares a character to walk in, and "loads" the dialogue that will happen
func walk_in(character_data : CharacterData):
	leave_animation.play("RESET")
	character.texture = character_data.art
	character.scale = Vector2(character_data.scale, character_data.scale)
	
	walk.play("character_walk")
	step.play("character_step")

func _on_character_walk_animation_finished(_anim_name):
	step.stop(true)
	finished_walking.emit()

func on_finished_talking ():
	leave_animation.play("leave")


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			character_clicked.emit()
