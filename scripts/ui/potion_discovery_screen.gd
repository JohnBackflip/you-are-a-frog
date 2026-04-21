extends Control

@onready var potion_image: TextureRect = $VBoxContainer/PotionImage


func display(potion: PotionData) -> void:
	potion_image.texture = potion.art
	var tween = create_tween()
	tween.tween_property(self, "modulate", modulate, 0.1).from(Color(1,1,1,0))
	
	
func close() -> void:
	queue_free()
