extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var reactions: Array = ["poisoned", "energized", "healed", "sleepy"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func taste_potion(potion: PotionData) -> void:
	var primary_property = potion.primary_property
	if primary_property:
		react(primary_property)


func react(primary_property: IngredientProperty) -> void:
	var effect = primary_property.name
	if effect == "Poisonous":
		animated_sprite_2d.play("disgusted")
	elif effect == "Energizing" or effect == "Medical" or effect == "Euphoric":
		animated_sprite_2d.play("happy")
	elif effect == "Somniferous":
		animated_sprite_2d.play("drowsy")
	var timer = get_tree().create_timer(3.0)
	await timer.timeout
	play_default_animation()


func get_current_animation() -> String:
	return animated_sprite_2d.animation


func play_drinking_animation() -> void:
	animated_sprite_2d.play("drinking")
	
	
func play_default_animation() -> void:
	animated_sprite_2d.play("default")
