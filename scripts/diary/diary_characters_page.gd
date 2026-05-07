extends Control

@export var character_set: Resource
@onready var characters: Control = $Characters
@onready var character_info_popup: Control = $CharacterInfoPopup

var num_entries: int = 8
var character_datas: Array[CharacterData]
var character_index: int


func _ready() -> void:
	update_data()


func update_data() -> void:
	character_index = 0
	for character_data in character_set.characters:
		if character_data not in character_datas: #and character_data.met:
			character_datas.append(character_data)
	populate_data()


func populate_data() -> void:
	# Clear previous data
	for art: TextureRect in characters.get_children():
		art.texture = null
		if art.gui_input.is_connected(on_character_selected):
			art.gui_input.disconnect(on_character_selected)
	
	for i in range(num_entries):
		if character_index > character_datas.size() - 1:
			return
		
		var character_data = character_datas[character_index] as CharacterData
		var character_arts = characters.get_children()
		var character_art = character_arts[character_index % num_entries] as TextureRect
		character_art.texture = character_data.icon
		character_art.gui_input.connect(on_character_selected.bind(character_data))
		 
		character_index += 1


func on_character_selected(event: InputEvent, character_data: CharacterData) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		character_info_popup.populate_character_info(character_data)
		character_info_popup.display()
	
