extends Control

@export var target_page: PackedScene

@onready var glow: TextureRect = $Glow

signal request_page_change(new_page: PackedScene)


func _ready() -> void:
	glow.hide()
	gui_input.connect(_on_gui_input)


func _on_mouse_entered() -> void:
	glow.show()


func _on_mouse_exited() -> void:
	glow.hide()


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		request_page_change.emit(target_page)
