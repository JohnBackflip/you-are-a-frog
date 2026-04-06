extends Node2D

# This is set to the demo inventory for now, change when needed. Might have to change these to global variables
var player_inventory_data: InventoryData
var mixer_data: MixerData
var character_set: CharacterSet

@onready var crafting_interface: Control = $CanvasLayer/CraftingInterface
@onready var cauldron: Area2D = $Cauldron
@onready var book: Area2D = $Book


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect signals
	cauldron.toggle_crafting_mode.connect(crafting_interface.on_toggle_crafting_mode)
	
	# Initialise inventory and mixer
	player_inventory_data = game_manager.player_inventory_data
	mixer_data = game_manager.mixer_data
	crafting_interface.set_player_inventory_data(player_inventory_data)
	crafting_interface.set_mixer_data(mixer_data)
