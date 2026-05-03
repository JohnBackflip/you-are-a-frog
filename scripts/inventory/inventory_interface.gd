extends Control
class_name InventoryInterface

@onready var player_inventory: Inventory = $PlayerInventory
@onready var item_description : Control = $PlayerInventory/CanvasLayer/ItemDescription
@onready var grabbed_slot: PanelContainer = $GrabbedSlot

var grabbed_slot_data: SlotData

func _physics_process(_delta: float) -> void:
	if grabbed_slot.visible:
		grabbed_slot.position = get_global_mouse_position()

func highlight_potion_tab():
	player_inventory.highlight_potion_tab()

# Initialise player inventory
func set_player_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	inventory_data.inventory_show_tooltip.connect(on_show_tooltip)
	inventory_data.inventory_hide_tooltip.connect(on_hide_tooltip)
	player_inventory.set_inventory_data(inventory_data)

func on_show_tooltip(inventory_data: InventoryData, index: int, pos : Vector2) -> void:
	if (inventory_data is MixerData):
		item_description.set_info(inventory_data.slot_datas_ingredient[index])
	else:
		item_description.set_info(inventory_data.slot_datas_ingredient[index] if player_inventory.current_tab == game_manager.InventoryTab.INGREDIENT else inventory_data.slot_datas_potion[index])
	item_description.show()
	item_description.position.x = player_inventory.position.x - item_description.size.x
	item_description.position.y = pos.y

func on_hide_tooltip() -> void:
	item_description.hide()

# Grab or place selected item from the inventory 
func on_inventory_interact(inventory_data: InventoryData, index: int, button: int) -> void:
	# This is pretty much an if statement but more convenient
	match [grabbed_slot_data, button]:
		[null, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.grab_slot_data(index, player_inventory.current_tab if inventory_data is not MixerData else game_manager.InventoryTab.INGREDIENT)
		[_, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data, index, player_inventory.current_tab if inventory_data is not MixerData else game_manager.InventoryTab.INGREDIENT)
				
	update_grabbed_slot()

# Update cursor whenever an item is grabbed
func update_grabbed_slot() -> void:
	if grabbed_slot_data:
		grabbed_slot.show()
		grabbed_slot.set_slot_data(grabbed_slot_data)
	else:
		grabbed_slot.hide()
