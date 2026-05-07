extends InventoryInterface

func give_potion() -> void:
	if (grabbed_slot.visible and grabbed_slot_data):
		if (grabbed_slot_data.item_data is PotionData):
			if !grabbed_slot_data.item_consumed.is_connected(grabbed_slot.on_item_consumed):
				grabbed_slot_data.item_consumed.connect(grabbed_slot.on_item_consumed)
			game_events.potion_given.emit(grabbed_slot_data.item_data)
			grabbed_slot_data.consume_item()
			if (grabbed_slot_data.quantity <= 0):
				grabbed_slot_data = null
