extends Resource
class_name ItemData

@export var name: String
@export var art: Texture
@export_multiline var description: String
@export var stackable: bool = true
@export var sound : AudioStream = preload("res://assets/audio/ingredients/drop_wood.wav")
