extends Control

@onready var character_art: TextureRect = $Panel/PanelContainer/MarginContainer/CharacterArt
@onready var character_name: Label = $Panel/InfoContainer/CharacterName
@onready var character_faction: Label = $Panel/InfoContainer/CharacterFaction
@onready var character_background: Label = $Panel/ScrollContainer/CharacterBackground


func _ready() -> void:
	hide()


func display() -> void:
	show()
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.1).from(0.0)
	

func _on_background_overlay_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var tween = create_tween()
		tween.tween_property(self, "modulate:a", 0.0, 0.1).from(1.0)
		await tween.finished
		hide()


func populate_character_info(character_data: CharacterData) -> void:
	var faction = CharacterData.ALIGNMENT.keys()[character_data.alignment]
	
	character_name.text = character_data.name
	character_faction.text = faction
	character_background.text = character_data.background
	character_art.texture = character_data.art
