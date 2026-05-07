extends Control

@onready var label : Label = $Label

func _ready() -> void:
	game_events.ending_reached.connect(on_ending_reached)
	game_events.scene_loaded.emit(self)

func on_ending_reached (data : EndingData):
	label.text = data.description
