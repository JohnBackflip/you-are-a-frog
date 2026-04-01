extends Node2D

# This is set to the demo inventory for now, change when needed
const PLAYER_INVENTORY_DATA = preload("uid://eajge1jeea0y")
const MIXER_DATA = preload("uid://ctskj2xpfe8fy")

@onready var ui: Control = $CanvasLayer/UI


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui.set_player_inventory_data(PLAYER_INVENTORY_DATA)
	ui.set_mixer_data(MIXER_DATA)
