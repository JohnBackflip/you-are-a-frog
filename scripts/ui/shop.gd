extends Node2D
class_name Shop

@onready var companion: Area2D = $Companion
@onready var crafting_interface : Control = $CanvasLayer/CraftingInterface

# This is set to the demo inventory for now, change when needed. Might have to change these to global variables
var player_inventory_data: InventoryData

func _ready() -> void:
	# Connect signals
	companion.mouse_entered.connect(_on_companion_mouse_entered)
	companion.mouse_exited.connect(_on_companion_mouse_exited)
	companion.input_event.connect(_on_companion_input_event)
	
	# Initialise inventory and mixer
	player_inventory_data = game_manager.player_inventory_data


func _on_companion_mouse_entered() -> void:
	if companion.get_current_animation() == "default":
		var grabbed_slot_data = crafting_interface.grabbed_slot_data
		if grabbed_slot_data and grabbed_slot_data.item_data is PotionData:
			companion.play_drinking_animation()

func _on_companion_mouse_exited() -> void:
	if companion.get_current_animation() == "drinking":
		companion.play_default_animation()

func _on_companion_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		if crafting_interface.visible and companion.get_current_animation() == "drinking":
			var grabbed_slot_data = crafting_interface.grabbed_slot_data
			if grabbed_slot_data and grabbed_slot_data.item_data is PotionData:
				companion.taste_potion(grabbed_slot_data.item_data)
				crafting_interface.update_grabbed_slot()
