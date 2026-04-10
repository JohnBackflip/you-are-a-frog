extends Control

@export var mixer_data: MixerData

@onready var ring: TextureProgressBar = $Ring
@onready var slots: Control = $Slots
@onready var property_bars: Control = $PropertyBars
@onready var craft_button: Button = %CraftButton
@onready var potion_slot: PotionSlot = $PotionSlot

const PROPERTY_BAR = preload("uid://qsvuyflknd5j")
const SLOT = preload("uid://bj32pp33u7ou4")

var ring_radius: float
var crafting_ingredients: Array[IngredientData]
var potion_slot_data: SlotData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect signals
	craft_button.pressed.connect(on_craft_button_pressed)
	potion_slot.collect_potion.connect(request_potion_storage)
	
	ring_radius = min(ring.size.x, ring.size.y) / 2
	if mixer_data:
		layout_slots(mixer_data)


func on_craft_button_pressed() -> void:
	if potion_slot_data:
		print("There is still a potion inside the mixer!")
		return
	var result_potion: PotionData = game_manager.encyclopedia.find_craftable_potion(crafting_ingredients)
	potion_slot_data = SlotData.new()
	potion_slot_data.item_data = result_potion
	potion_slot.set_slot_data(potion_slot_data)
	
	# Consume items in potion slot (all of them for now, to change for partial recipes)
	for index in range(mixer_data.slot_datas.size()):
		var slot_data = mixer_data.slot_datas[index]
		if slot_data:
			slot_data.consume_item()
			if slot_data.quantity <= 0:
				mixer_data.slot_datas[index] = null

	mixer_data.inventory_updated.emit(mixer_data)
	game_events.potion_discovered.emit(result_potion)

func request_potion_storage() -> void:
	if potion_slot_data:
		var potion = potion_slot_data.item_data as PotionData
		print("potion name:", potion.name)
		var success = game_manager.player_inventory_data.add_item(potion)
		if success:
			print("Potion store success!")
			potion_slot.set_slot_data(null)
			potion_slot_data = null
		

# Update whenever ingredients are added or removed to the mixer slots
func on_ingredients_update(new_mixer_data: MixerData, ingredients: Array[IngredientData]) -> void:
	mixer_data = new_mixer_data
	layout_slots(new_mixer_data)
	if ingredients and ingredients.size() >= 2:
		craft_button.show()
		crafting_ingredients = ingredients
	else:
		craft_button.hide()

# Initialise slots around the ring and progress bars
func layout_slots(mixer: MixerData):
	# Clear slots and property bars
	for child in slots.get_children():
		child.queue_free()
	for child in property_bars.get_children():
		child.queue_free()
	
	var mixer_size = mixer.slot_datas.size()

	# Calculate the angle step (e.g., 360 / 3 = 120 degrees)
	var angle_step = 360.0 / mixer_size

	var center = size / 2

	for i in range(mixer_size):
		var slot_data = mixer.slot_datas[i]
		print("Slot data:", slot_data)
		var slot = SLOT.instantiate()
		slot.slot_clicked.connect(mixer_data.on_slot_clicked)
		slot.index = i
		slots.add_child(slot)
		if slot_data:
			slot.set_slot_data(slot_data)
			slot_data.item_consumed.connect(slot.on_item_consumed)
		
		# 1. Calculate angle in degrees, then convert to radians
		# Subtract 90 to start at the "Top" (12 o'clock) instead of the "Right"
		var angle_deg = (i * angle_step) - 90
		var angle_rad = deg_to_rad(angle_deg)
		
		# 2. Calculate coordinates relative to center
		var x = cos(angle_rad) * (ring_radius + 50.0)
		var y = sin(angle_rad) * (ring_radius + 50.0)
		
		# 3. Set the position
		slot.position = center + Vector2(x, y) - (slot.size / 2)
		
		# 4. Add a progress bar corresponding to this slot
		var property_bar = PROPERTY_BAR.instantiate() as TextureProgressBar
		property_bar.position = ring.position
		property_bar.radial_initial_angle = angle_deg + 90
		property_bar.max_value = mixer_size
		property_bar.value = 0.0
		if slot_data and slot_data.item_data:
			if slot_data.item_data is IngredientData:
				var item = slot_data.item_data as IngredientData
				property_bar.tint_progress = item.property.colour
				property_bar.value = 1.0
		property_bars.add_child(property_bar)
