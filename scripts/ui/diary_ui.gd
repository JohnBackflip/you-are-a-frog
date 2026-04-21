extends Control

@onready var background_overlay: ColorRect = $BackgroundOverlay
@onready var page: Control = $Page
@onready var bookmarks: Control = $Bookmarks

var current_page_scene: PackedScene = preload("uid://ds0k76ll33rf6") #Set default page to orders


func _ready() -> void:
	game_events.open_potion_diary.connect(open_diary)
	for bookmark in bookmarks.get_children():
		bookmark.request_page_change.connect(on_request_page_change)
		
	update_bookmarks()


func on_request_page_change(target_page: PackedScene) -> void:
	if target_page:
		current_page_scene = target_page
		page.get_child(0).queue_free()
		var new_page = target_page.instantiate()
		page.add_child(new_page)
		update_bookmarks()


func update_bookmarks() -> void:
	for bookmark in bookmarks.get_children():
		if bookmark.target_page == current_page_scene:
			bookmark.hide()
		else:
			if !bookmark.visible:
				bookmark.show()


func _on_background_overlay_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		close_diary()


func open_diary() -> void:
	show()
	var tween = create_tween()
	tween.tween_property(background_overlay, "self_modulate", background_overlay.self_modulate, 0.1).from(Color(0.0, 0.0, 0.0, 0.0))
	tween.parallel().tween_property(page, "position", page.position, 0.15).from(page.position + Vector2(0.0, 500.0))
	
	
func close_diary() -> void:
		var initial_modulate = background_overlay.self_modulate
		var initial_position = page.position
		var tween = create_tween()
		tween.tween_property(background_overlay, "self_modulate", Color(0.0, 0.0, 0.0, 0.0), 0.1)
		tween.parallel().tween_property(page, "position", page.position + Vector2(0.0, 500.0), 0.15)
		await tween.finished
		hide()
		# Reset items to original values
		background_overlay.self_modulate = initial_modulate
		page.position = initial_position
