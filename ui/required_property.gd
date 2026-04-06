extends PanelContainer

@onready var property_icon_texture: TextureRect = %PropertyIcon


func set_property_icon(property_icon: Texture):
	property_icon_texture.texture = property_icon
