extends Control
class_name InventoryInterface

@onready var ingredient_inventory: Inventory = $IngredientInventory
@onready var potion_inventory: Inventory = $PotionInventory
@onready var mixer_inventory : Inventory = $Mixer
@onready var item_description : Control = $ItemDescription
@onready var grabbed_slot: PanelContainer = $GrabbedSlot

var grabbed_slot_data: SlotData

func _physics_process(_delta: float) -> void:
	if grabbed_slot.visible:
		grabbed_slot.position = get_global_mouse_position()

# Initialise player inventory
func set_player_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	inventory_data.inventory_show_tooltip.connect(on_show_tooltip)
	inventory_data.inventory_hide_tooltip.connect(on_hide_tooltip)
	ingredient_inventory.set_inventory_data(inventory_data)
	potion_inventory.set_inventory_data(inventory_data)

func on_show_tooltip(inventory_data: InventoryData, index: int, inventory : Inventory) -> void:
	var has_text : bool
	if (inventory_data is MixerData or  inventory is IngredientInventory):
		has_text = item_description.set_info(inventory_data.slot_datas_ingredient[index])
	else:
		has_text = item_description.set_info(inventory_data.slot_datas_potion[index])
	
	item_description.visible = has_text

func on_hide_tooltip() -> void:
	item_description.hide()

# Grab or place selected item from the inventory 
func on_inventory_interact(inventory : Inventory, inventory_data: InventoryData, index: int, button: int) -> void:
	# This is pretty much an if statement but more convenient
	match [grabbed_slot_data, button]:
		[null, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.grab_slot_data(index, inventory)
		[_, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data, index, inventory)
	
	mixer_inventory.holding_item = grabbed_slot_data != null
	update_grabbed_slot()

# Update cursor whenever an item is grabbed
func update_grabbed_slot() -> void:
	if grabbed_slot_data:
		grabbed_slot.show()
		grabbed_slot.set_slot_data(grabbed_slot_data)
	else:
		grabbed_slot.hide()
