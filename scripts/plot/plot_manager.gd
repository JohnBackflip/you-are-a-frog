extends Resource
class_name PlotManager

const end_scene : String = "res://scenes/endings/ending.tscn"

# Dictionary of all possible endings. Different choices will add to different endings (points can differ)
# Whenever a threshold is reached, that ending happens
@export var endings : Dictionary[EndingData, int] ={load("res://resources/plot/neutral_ending.tres") : 0,
											 		load("res://resources/plot/guard_ending.tres") : 0,
													load("res://resources/plot/rebel_ending.tres") : 0}

func go_to_ending():
	game_manager.load_scene(end_scene)
	var possible_endings : Array[EndingData] = endings.keys().filter(func(key): return endings[key] == endings.values().max())
	var end : EndingData
	if (possible_endings.size() > 1):
		print("Neutral")
		end = endings.find_key(endings.values().min())
	else:
		print(possible_endings)
		end = possible_endings[0]
	await game_events.scene_loaded
	game_events.ending_reached.emit(end)
	#end_scene.fill(endings.find_key(endings.values().max()))
