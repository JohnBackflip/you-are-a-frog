extends Area2D

@onready var sprite: AnimatedSprite2D = $Sprite


func _on_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property(sprite, "modulate", Color(1.5, 1.5, 1.5), 0.1)
	tween.parallel().tween_property(sprite, "scale", Vector2(1.05, 1.05), 0.1)


func _on_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(sprite, "modulate", Color(1, 1, 1), 0.1)
	tween.parallel().tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.1)


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			print("recipe book clicked!")
