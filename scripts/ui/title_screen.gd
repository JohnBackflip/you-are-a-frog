extends Control

signal switch_bg(mode: Mode)

enum Mode {DAY, NIGHT}


func _ready() -> void:
	switch_bg.connect(change_background)
	change_background(Mode.DAY)


func change_background(mode: Mode) -> void:
	var timer = get_tree().create_timer(5.0)
	await timer.timeout
	var tween = create_tween()
	if mode == Mode.DAY:
		tween.tween_property($DayMenu, "modulate:a", 0, 3.0).from(1).set_trans(Tween.TRANS_SINE)
		tween.parallel().tween_property($NightMenu, "modulate:a", 1, 3.0).from(0).set_trans(Tween.TRANS_SINE)
		await tween.finished
		switch_bg.emit(Mode.NIGHT)
	else:
		tween.tween_property($DayMenu, "modulate:a", 1, 3.0).from(0).set_trans(Tween.TRANS_SINE)
		tween.parallel().tween_property($NightMenu, "modulate:a", 0, 3.0).from(1).set_trans(Tween.TRANS_SINE)
		await tween.finished
		switch_bg.emit(Mode.DAY)


func _on_start_button_pressed() -> void:
	game_manager.load_scene("res://scenes/shop/day_shop.tscn")
