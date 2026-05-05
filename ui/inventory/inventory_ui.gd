extends Control

@onready var sprite : AnimatedSprite2D = $Sprite

func _ready() -> void:
	sprite.animation = "day" if game_manager.period == game_manager.Period.DAY else "night"
