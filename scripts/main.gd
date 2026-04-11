extends Node2D

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var crafting_interface: Control = $CanvasLayer/CraftingInterface
@onready var cauldron: Area2D = $Cauldron
@onready var companion: Area2D = $Companion

# This is set to the demo inventory for now, change when needed. Might have to change these to global variables
var player_inventory_data: InventoryData
var mixer_data: MixerData
var character_set: CharacterSet

const POTION_DISCOVERY_SCREEN = preload("uid://v6wkfrj1f6om")


func _ready() -> void:
	# Connect signals
	cauldron.toggle_crafting_mode.connect(crafting_interface.on_toggle_crafting_mode)
	game_events.potion_discovered.connect(on_potion_discovered)
	companion.mouse_entered.connect(_on_companion_mouse_entered)
	companion.mouse_exited.connect(_on_companion_mouse_exited)
	companion.input_event.connect(_on_companion_input_event)
	
	# Initialise inventory and mixer
	player_inventory_data = game_manager.player_inventory_data
	mixer_data = game_manager.mixer_data
	crafting_interface.set_player_inventory_data(player_inventory_data)
	crafting_interface.set_mixer_data(mixer_data)


func _on_companion_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		if crafting_interface.visible and companion.get_current_animation() == "drinking":
			var grabbed_slot_data = crafting_interface.grabbed_slot_data
			if grabbed_slot_data and grabbed_slot_data.item_data is PotionData:
				companion.taste_potion(grabbed_slot_data.item_data)


func _on_companion_mouse_entered() -> void:
	if crafting_interface.visible and companion.get_current_animation() == "default":
		var grabbed_slot_data = crafting_interface.grabbed_slot_data
		if grabbed_slot_data and grabbed_slot_data.item_data is PotionData:
			companion.play_drinking_animation()


func _on_companion_mouse_exited() -> void:
	if companion.get_current_animation() == "drinking":
		companion.play_default_animation()


func on_potion_discovered(potion: PotionData) -> void:
	var discovery_screen = POTION_DISCOVERY_SCREEN.instantiate()
	canvas_layer.add_child(discovery_screen)
	discovery_screen.display(potion)
	
