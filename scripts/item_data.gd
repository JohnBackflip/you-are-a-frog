extends Resource
class_name ItemData

enum Property {HEALING, POISONOUS}

@export var name: String
@export var texture: Texture
@export_multiline var description: String
@export var property: Property
@export_range(1,3) var potency: int
@export var stackable: bool = true
