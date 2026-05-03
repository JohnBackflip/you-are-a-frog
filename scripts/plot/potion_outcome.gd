class_name PotionOutcome
extends Resource

# How the character will react next time
@export var dialogue_outcome : String

# What "quest" they will give next
@export var next_dialogue: TimelineData

# What ending it gears towards
@export var endings : Array[EndingPoints]
