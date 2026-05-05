extends Inventory
class_name MixerInventory

signal craft_mixer

@export var mixer_data: MixerData

@onready var slots: Control = $Slots

var crafting_ingredients: Array[IngredientData]
var potion_slot_data: SlotData

var can_craft : bool = false
var last_slot : int = 0
var holding_item : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pivot_offset = size/2
	if mixer_data:
		layout_slots(mixer_data)


func craft() -> void:
	var result_potion: PotionData = game_manager.encyclopedia.find_craftable_potion(crafting_ingredients)
	potion_slot_data = SlotData.new()
	potion_slot_data.item_data = result_potion
	
	# Consume items in potion slot (all of them for now, to change for partial recipes)
	for index in range(mixer_data.slot_datas_ingredient.size()):
		var slot_data = mixer_data.slot_datas_ingredient[index]
		if slot_data:
			slot_data.consume_item()
			if slot_data.quantity <= 0:
				mixer_data.slot_datas_ingredient[index] = null
	
	# Play some animation here
	mixer_data.inventory_updated.emit(mixer_data)
	if result_potion.recipe and result_potion.recipe_unlocked == false:
		game_events.potion_discovered.emit(result_potion)
		result_potion.recipe_unlocked = true
		print("New potion %s discovered!" % result_potion.name)
	request_potion_storage()

func request_potion_storage() -> void:
	if potion_slot_data:
		var potion = potion_slot_data.item_data as PotionData
		print("potion name:", potion.name)
		var success = game_manager.player_inventory_data.add_item(potion)
		if success:
			print("Potion store success!")
			potion_slot_data = null

func request_ingredients_storage() -> void:
	for index in range(mixer_data.slot_datas_ingredient.size()):
		var slot_data = mixer_data.slot_datas_ingredient[index]
		if slot_data:
			print("Ingredient name:", slot_data.item_data.name)
			var success = game_manager.player_inventory_data.add_item(slot_data.item_data, slot_data.quantity)
			if success:
				print("Ingredient store success!")
				mixer_data.slot_datas_ingredient[index] = null

	layout_slots(mixer_data)

# Update whenever ingredients are added or removed to the mixer slots
func on_ingredients_update(new_mixer_data: MixerData, ingredients: Array[IngredientData]) -> void:
	mixer_data = new_mixer_data
	layout_slots(new_mixer_data)
	if ingredients and ingredients.size() >= 2:
		can_craft = true
		crafting_ingredients = ingredients
	else:
		can_craft = false

# Initialise slots inside the mixer
func layout_slots(mixer: MixerData):
	# Clear slots and property bars
	for child in slots.get_children():
		child.queue_free()
	last_slot = 0
	var mixer_size = mixer.slot_datas_ingredient.size()

	var center = Vector2(slots.size.x/2, slots.size.y-64)

	for i in range(1, mixer_size):
		if (mixer.slot_datas_ingredient[i-1]) == null:
			mixer.slot_datas_ingredient[i-1] = mixer.slot_datas_ingredient[i]
			mixer.slot_datas_ingredient[i] = null
	
	for i in range(mixer_size):
		var slot_data = mixer.slot_datas_ingredient[i]
		var slot = SLOT.instantiate()
		slot.slot_clicked.connect(mixer_data.on_slot_clicked)
		slot.slot_hovered.connect(mixer_data.on_slot_hovered)
		slot.slot_hover_left.connect(mixer_data.on_slot_hover_left)
		slot.parent_inventory = self
		slot.index = i
		slot.modulate = "aaffff"
		# Rotate slightly, as if moved
		slots.add_child(slot)
		if slot_data:
			last_slot += 1
			slot.set_slot_data(slot_data)
			slot_data.item_consumed.connect(slot.on_item_consumed)
			slot.rotation =(randf())*1.5
			slot.position = center - Vector2((i%2)*slot.size.x/2, slot.size.y*i)
				

func save_contents() -> void:
	request_ingredients_storage()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		if (last_slot < mixer_data.slot_datas_ingredient.size()):
			mixer_data.on_slot_clicked(last_slot, event.button_index, self)


func _on_handle_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		if (can_craft):
			craft_mixer.emit()

func _on_mouse_entered() -> void:
	if (can_craft or holding_item):
		var tween = create_tween()
		tween.tween_property(self, "modulate", Color(1.2, 1.2, 1.2), 0.1)
		tween.parallel().tween_property(self, "scale", Vector2(1.05, 1.05), 0.1)


func _on_mouse_exited() -> void:
	if (can_craft or holding_item):
		var tween = create_tween()
		tween.tween_property(self, "modulate", Color(1, 1, 1), 0.1)
		tween.parallel().tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
