extends Shop

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var cauldron: Sprite2D = $CanvasLayer/CraftingInterface/Cauldron

# This is set to the demo inventory for now, change when needed. Might have to change these to global variables
var mixer_data: MixerData
var character_set: CharacterSet

const POTION_DISCOVERY_SCREEN = preload("res://scenes/crafting/potion_discovery_screen.tscn")


func _ready() -> void:
	super()
	# Connect signals
	game_events.potion_discovered.connect(on_potion_discovered)
	
	# Initialise inventory and mixer
	mixer_data = game_manager.mixer_data
	crafting_interface.set_player_inventory_data(player_inventory_data)
	crafting_interface.set_mixer_data(mixer_data)

func on_potion_discovered(potion: PotionData) -> void:
	var discovery_screen = POTION_DISCOVERY_SCREEN.instantiate()
	canvas_layer.add_child(discovery_screen)
	discovery_screen.display(potion)
	

func _on_end_night_button_pressed() -> void:
	game_manager.day += 1
	var day_shop = preload("res://scenes/shop/day_shop.tscn").instantiate()
	game_manager.period = game_manager.Period.DAY
	crafting_interface.save_mixer_contents()
	#day_shop.modulate.a = 0
	get_parent().add_child(day_shop)
	move_to_front()
	var tween = create_tween()
	tween.tween_property(self.get_node("CanvasLayer/CraftingInterface"), "modulate:a", 0.0, 0.2)
	tween.tween_property(self.get_node("%Cauldron"), "modulate:a", 0.0, 0.5)
	tween.tween_property(self, "modulate:a", 0, 2.0)
	#tween.parallel().tween_property(day_shop.get_node("Background"), "modulate:a", 1, 1.0)
	await tween.finished
	# Reset transparency
	self_modulate.a = 1
	queue_free()
