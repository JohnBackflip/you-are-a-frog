extends Control

@onready var label : RichTextLabel = $Label

func _ready() -> void:
	game_events.ending_reached.connect(on_ending_reached)
	game_events.scene_loaded.emit(self)

func on_ending_reached (data : EndingData):
	label.set_text(data.get_text())
