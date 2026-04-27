extends Resource
class_name CharacterData

enum ALIGNMENT {Good, Bad, Neutral}

@export var name : String
@export var alignment : ALIGNMENT
@export var art: Texture
@export var color : String
@export var icon : Texture
@export var scale : float

var dialogue_index : int = 0
