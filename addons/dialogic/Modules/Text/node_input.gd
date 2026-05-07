class_name DialogicNode_Input
extends Control

## A node that handles mouse input. This allows limiting mouse input to a
## specific region and avoiding conflicts with other UI elements.
## If no Input node is used, the input subsystem will handle mouse input instead

func _ready() -> void:
	add_to_group('dialogic_input')
	gui_input.connect(_on_gui_input)

func _input(_event: InputEvent) -> void:
	pass


func _on_gui_input(event:InputEvent) -> void:
	pass
