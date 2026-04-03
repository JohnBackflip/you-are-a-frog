extends Node2D

# This is set to the demo inventory for now, change when needed
const PLAYER_INVENTORY_DATA = preload("uid://eajge1jeea0y")
const MIXER_DATA = preload("uid://ctskj2xpfe8fy")

@onready var crafting_interface: Control = $CanvasLayer/CraftingInterface
@onready var cauldron: Area2D = $Cauldron


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect signals
	cauldron.toggle_crafting_mode.connect(crafting_interface.on_toggle_crafting_mode)
	
	# Initialise inventory and mixer
	crafting_interface.set_player_inventory_data(PLAYER_INVENTORY_DATA)
	crafting_interface.set_mixer_data(MIXER_DATA)
