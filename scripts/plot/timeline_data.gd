extends Resource
class_name TimelineData

@export var dialogic_timeline : Resource

@export var potion_given : PotionData
# What dialogue they'll respond with, what the next dialogue will be and what ending it leads towards
@export var outcome : Dictionary[PotionData, PotionOutcome]
