extends Control

@onready var texture_rect: TextureRect = $TextureRect

var scene_path: String
var progress := []
var scene_load_status: int = 0


func _ready() -> void:
	scene_path = game_manager.target_scene_path
	start_loading_animation()
	ResourceLoader.load_threaded_request(scene_path)
	

func _process(_delta: float) -> void:
	scene_load_status = ResourceLoader.load_threaded_get_status(scene_path, progress)
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var target_scene = ResourceLoader.load_threaded_get(scene_path)
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_packed(target_scene)


func start_loading_animation() -> void:
	var tween = create_tween()
	tween.tween_property(texture_rect, "self_modulate", Color(0,0,0,1), 0.2).from(Color(0,0,0,0))
	await tween.finished


func end_loading_animation() -> void:
	var tween = create_tween()
	tween.tween_property(texture_rect, "self_modulate", Color(0,0,0,0), 0.2).from(Color(0,0,0,1))
	await tween.finished
