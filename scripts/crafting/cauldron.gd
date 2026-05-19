extends Sprite2D

@export var cauldron_boiling : AudioStream = preload("res://assets/audio/ingredients/boiling.wav")
@onready var audio_source : AudioStreamPlayer2D = $Bubbler
@onready var particles : AnimationPlayer = $ParticleController

@export var mixer_into_cauldron_audio : AudioStream = preload("res://assets/audio/ingredients/drop_cauldron.mp3")

func bubble() -> void:
	game_functions.play_audio(audio_source, mixer_into_cauldron_audio)
	particles.play("fade_in")
	await audio_source.finished
	game_functions.play_audio(audio_source, cauldron_boiling)
	await audio_source.finished
	particles.play("RESET")
