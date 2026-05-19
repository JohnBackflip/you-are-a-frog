# Contains global functions that any node can use
extends Node

func play_audio (player : AudioStreamPlayer2D, sound : AudioStream) -> void:
	player.stream = sound
	player.play()
