# Handles interactions between the player and game
extends InventoryInterface

@onready var craft_button: Button = $CraftButton
@onready var mixer: Control = %Mixer

func on_toggle_crafting_mode() -> void:
	mixer.visible = not mixer.visible
	craft_button.visible = mixer.visible and craft_button.visible
	if (!mixer.visible):
		save_mixer_contents()

# Returns the contents of the mixer to the inventory
func save_mixer_contents() -> void:
	mixer.save_contents()

# Initialise ingredient mixer (behaves like an inventory)
func set_mixer_data(mixer_data: MixerData) -> void:
	mixer_data.inventory_interact.connect(on_inventory_interact)
	if !mixer_data.inventory_updated.is_connected(mixer_data.on_inventory_update):
		mixer_data.inventory_updated.connect(mixer_data.on_inventory_update)
	mixer_data.inventory_show_tooltip.connect(on_show_tooltip)
	mixer_data.inventory_hide_tooltip.connect(on_hide_tooltip)

	# Connect signals
	mixer_data.mixer_contents.connect(mixer.on_ingredients_update)
