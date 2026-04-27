# Contains global signals that any node can use
extends Node

signal scene_loaded(scene: PackedScene)

signal open_potion_diary
signal potion_discovered(potion: PotionData)

signal new_order(customer: CharacterData, request: String, deadline: int, desired_undesired : Dictionary)
signal potion_given(potion_data : PotionData)
