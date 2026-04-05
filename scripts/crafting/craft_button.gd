extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func on_mixer_full(full: bool) -> void:
	if full:
		show()
	else:
		hide()
		

func _on_pressed() -> void:
	# Insert code to craft a potion
	print("Potion crafted!")
