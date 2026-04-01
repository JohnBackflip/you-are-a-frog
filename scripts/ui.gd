# Handles interactions between the player and game
extends Control

@onready var player_inventory: PanelContainer = $PlayerInventory
@onready var grabbed_slot: PanelContainer = $GrabbedSlot
@onready var mixer: PanelContainer = $Mixer
@onready var craft_button: Button = $CraftButton

var grabbed_slot_data


func _physics_process(_delta: float) -> void:
	if grabbed_slot.visible:
		grabbed_slot.position = get_global_mouse_position()


# Initialise player inventory
func set_player_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	player_inventory.set_inventory_data(inventory_data)
	
	
# Initialise ingredient mixer (behaves like an inventory)
func set_mixer_data(mixer_data: MixerData) -> void:
	mixer_data.inventory_interact.connect(on_inventory_interact)
	mixer_data.inventory_updated.connect(mixer_data.on_inventory_update)
	mixer.set_inventory_data(mixer_data)
	# Connect signal to button
	mixer_data.is_mixer_full.connect(craft_button.on_mixer_full)


# Grab or place selected item from the inventory 
func on_inventory_interact(inventory_data: InventoryData, index: int, button: int) -> void:
	# This is pretty much an if statement but more convenient
	match [grabbed_slot_data, button]:
		[null, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.grab_slot_data(index)
		[_, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data, index)
				
	update_grabbed_slot()


# Update cursor whenever an item is grabbed
func update_grabbed_slot() -> void:
	if grabbed_slot_data:
		grabbed_slot.show()
		grabbed_slot.set_slot_data(grabbed_slot_data)
	else:
		grabbed_slot.hide()
