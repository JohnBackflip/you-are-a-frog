extends Control

@export var entries_per_page: int = 4

@onready var background_overlay: ColorRect = $BackgroundOverlay
@onready var book: Control = $Book
@onready var page_1: VBoxContainer = $Book/Page1
@onready var page_2: VBoxContainer = $Book/Page2

const DIARY_ENTRY = preload("uid://bbgbt2amtl16h")

var encyclopedia: Encyclopedia
var potion_index: int # Keeps track of which potion to start from depending on page number


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	encyclopedia = game_manager.encyclopedia
	game_events.open_potion_diary.connect(open_diary)
	populate_diary()


# Call this whenever the player unlocks a new potion
func update_encyclopedia() -> void:
	encyclopedia = game_manager.encyclopedia


func populate_diary() -> void:
	if encyclopedia:
		populate_page(page_1, entries_per_page)
		populate_page(page_2, entries_per_page)


func populate_page(page: VBoxContainer, num_entries: int) -> void:
	for child in page.get_children():
		child.queue_free()
		
	for i in range(num_entries):
		print("Potion Index:", potion_index)
		if potion_index > encyclopedia.potions.size() - 1:
			return
			
		var potion = encyclopedia.potions[potion_index] as PotionData
		var recipe = potion.recipe
		if not recipe:
			potion_index += 1
			continue
		var property_count = {}
		# Count how many of each property is needed
		for step: RecipeStep in recipe.recipe_steps:
			var property: IngredientProperty = step.property
			property_count[property.icon] = property_count.get(property.icon, 0) + step.quantity
		# Create an entry
		var entry = DIARY_ENTRY.instantiate()
		page.add_child(entry)
		entry.populate_entry(potion.name, potion.art, property_count)
		potion_index += 1


func open_diary() -> void:
	show()
	var tween = create_tween()
	tween.tween_property(background_overlay, "self_modulate", background_overlay.self_modulate, 0.1).from(Color(0.0, 0.0, 0.0, 0.0))
	tween.parallel().tween_property(book, "position", book.position, 0.1).from(book.position + Vector2(0.0, 300.0))
	
func close_diary() -> void:
		var initial_modulate = background_overlay.self_modulate
		var initial_position = book.position
		var tween = create_tween()
		tween.tween_property(background_overlay, "self_modulate", Color(0.0, 0.0, 0.0, 0.0), 0.1)
		tween.parallel().tween_property(book, "position", book.position + Vector2(0.0, 300.0), 0.1)
		await tween.finished
		hide()
		# Reset items to original values
		background_overlay.self_modulate = initial_modulate
		book.position = initial_position
# Close diary
func _on_background_overlay_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		close_diary()
		
