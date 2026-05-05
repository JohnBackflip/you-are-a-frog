extends Resource
class_name CharacterData


@export var name : String
@export_enum("Castle Guards", "Merchant Guild", "Rebels") var faction : String
@export var art: Texture
@export var color : String
@export var icon : Texture
@export var scale : float
@export_multiline var background: String

@export var potion_given : PotionData
@export var timeline : TimelineData
var met: bool = false

func next_timeline(potion : PotionData) -> TimelineData:
	var next : TimelineData = timeline.outcome[potion].next_dialogue
	if (!next):
		next = timeline.outcome[null].next_dialogue
	return next
