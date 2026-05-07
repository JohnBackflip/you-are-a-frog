extends VBoxContainer

@onready var potion_name_label: Label = $PotionName
@onready var potion_icon_texture: TextureRect = $HBoxContainer/PotionIcon
@onready var required_properties: HBoxContainer = %RequiredProperties

const REQUIRED_PROPERTY = preload("uid://lh4vs3jsdx63")


func populate_entry(potion_name: String, potion_icon: Texture, property_count: Dictionary, is_unlocked: bool) -> void:
	for child in required_properties.get_children():
		child.queue_free()
	potion_icon_texture.texture = potion_icon
	if is_unlocked:
		potion_name_label.text = potion_name
	else:
		potion_name_label.text = "???"
		potion_icon_texture.set("self_modulate", Color(0,0,0,1))
	for property_icon in property_count.keys():
		var quantity = property_count[property_icon]
		for i in range(quantity):
			var req_property = REQUIRED_PROPERTY.instantiate()
			required_properties.add_child(req_property)
			req_property.set_property_icon(property_icon)
			
