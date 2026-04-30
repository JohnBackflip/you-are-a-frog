extends Resource
class_name CharacterData


@export var name : String
@export_enum("Castle Guards", "Merchant Guild", "Rebels") var faction : String
@export var art: Texture
@export var color : String
@export var icon : Texture
@export var scale : float
@export_multiline var background: String

var dialogue_index : int = 0
var met: bool = false
