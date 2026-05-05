# Handles interactions between the player and game
extends InventoryInterface

@onready var mixer: Control = %Mixer

func _ready() -> void:
	mixer.craft_mixer.connect(on_craft)

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

func on_craft() -> void:
	mixer.get_child(-1).play("pour_beaker")


func _on_mixer_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "pour_beaker"):
		mixer.craft()
		mixer.request_ingredients_storage()
		await get_tree().create_timer(1.0).timeout
		mixer.get_child(-1).play("return_beaker")
