extends Resource
class_name CharacterData

enum ALIGNMENT {Good, Bad, Neutral}

@export var name : String
@export var alignment : ALIGNMENT
@export var art: Texture
@export var dialog : Array[String]
