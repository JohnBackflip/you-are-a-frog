extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_player : AudioStreamPlayer2D = $AudioPlayer

@export var gulp_sound : AudioStream = preload("res://assets/audio/Ribbit/gulp.wav")
@export var mouth_sound : AudioStream = preload("res://assets/audio/Ribbit/open_mouth.wav")

var reactions: Array = ["poisoned", "energized", "healed", "sleepy"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func taste_potion(potion: PotionData) -> void:
	game_functions.play_audio(audio_player, gulp_sound)
	react(potion)


func react(potion: PotionData) -> void:
	# Add reactions
	# Now that ribbit has reacted, the art is how Ribbit reacted
	potion.art = potion.ribbit_art
	var timer = get_tree().create_timer(3.0)
	await timer.timeout
	play_default_animation()

func get_current_animation() -> String:
	return animated_sprite_2d.animation


func play_drinking_animation() -> void:
	game_functions.play_audio(audio_player, mouth_sound)
	animated_sprite_2d.play("drinking")
	
	
func play_default_animation() -> void:
	animated_sprite_2d.play("default")
