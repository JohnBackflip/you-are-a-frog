extends Control

@export var ingredients_folder: String = "res://resources/ingredients/"

@onready var grid_container: GridContainer = $GridContainer
@onready var ingredient_detail_art: TextureRect = $IngredientDetailArt
@onready var ingredient_detail_name: RichTextLabel = $IngredientDetailName
@onready var ingredient_detail_description: RichTextLabel = $IngredientDetailDescription

var ingredients: Array[IngredientData]
var ingredient_page_index: int = 0

func _ready() -> void:
	retrieve_ingredients()

	for i in range(16):
		var ingredient = null
		if i + ingredient_page_index < ingredients.size():
			ingredient = ingredients[i + ingredient_page_index]
			
		var ingredient_texture_rect = grid_container.get_child(i).get_child(0)
		if ingredient_texture_rect.gui_input.is_connected(_on_ingredient_clicked):
			ingredient_texture_rect.gui_input.disconnect(_on_ingredient_clicked)
			
		if ingredient:
			ingredient_texture_rect.texture = ingredient.art
			ingredient_texture_rect.gui_input.connect(_on_ingredient_clicked.bind(ingredient))
			if !ingredient.discovered:
				ingredient_texture_rect.self_modulate = Color(0,0,0,1)
		else:
			ingredient_texture_rect.texture = null


func retrieve_ingredients() -> void:
	var dir = DirAccess.open(ingredients_folder)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and (file_name.ends_with(".tres") or file_name.ends_with(".res")):
				var ingredient = load(ingredients_folder + "/" + file_name)
				if ingredient is IngredientData:
					ingredients.append(ingredient)
			file_name = dir.get_next()
			
		print("Loaded %d ingredients from folder!" % ingredients.size())
		

func display_ingredient_details(ingredient: IngredientData) -> void:
	ingredient_detail_art.texture = ingredient.art
	if ingredient.discovered:
		ingredient_detail_name.text = "[b]" + ingredient.name + "[/b]"
		ingredient_detail_description.text = ingredient.description
	else:
		ingredient_detail_art.self_modulate = Color(0,0,0,1)
		ingredient_detail_name.text = "[b]" + "???" + "[/b]"
		ingredient_detail_description.text = "This ingredient has not been discovered yet"
	

func _on_ingredient_clicked(event: InputEvent, ingredient: IngredientData) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		display_ingredient_details(ingredient)
