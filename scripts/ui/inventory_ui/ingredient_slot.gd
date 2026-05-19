extends Slot
class_name IngredientSlot

@onready var bag : AnimatedSprite2D = $Bag
@onready var bag_outline : AnimatedSprite2D = $Outline
@onready var bag_sound : AudioStreamPlayer2D = $OpenClose
@onready var shader : Shader = preload("res://resources/inventory/ingredient_slot.gdshader")

@export var sound_open : AudioStream = preload("res://assets/audio/bag/bag_open.wav")
@export var sound_take : AudioStream = preload("res://assets/audio/bag/bag_take.wav")
@export var sound_close : AudioStream = preload("res://assets/audio/bag/bag_close.mp3")

const colors : Array[float] = [0.0, 0.05, 0.29, 0.55, 0.68, 0.85]
@onready var own_color : Color

var is_open : bool = false

enum State {EMPTY, ONE, FULL}
var state : State = State.EMPTY

func change_anim():
	var appended : String = ""
	if state == State.EMPTY:
		appended = "_empty"
	elif state == State.ONE:
		appended = "_one"
	
	var anim
	if (is_open):
		anim = "opened" + appended
	else:
		anim = "closed" + appended
	bag.animation = anim
	bag_outline.animation = anim

func _ready() -> void:
	super()
	bag.material = ShaderMaterial.new()
	bag.material.shader = shader
	bag.material.set_shader_parameter("target_color", Color.from_hsv(colors[get_index()], 1.0, 0.74, 1.0))

func update_state(slot_data: SlotData):
	super.set_slot_data(slot_data)

	if !slot_data or slot_data.quantity <= 0:
		state = State.EMPTY
	elif slot_data.quantity <= 1:
		state = State.ONE
	else:
		state = State.FULL

func add_slot_data(slot_data: SlotData):
	update_state(slot_data)
	change_anim()

func set_slot_data(slot_data: SlotData):
	update_state(slot_data)
	change_anim()
	game_functions.play_audio(bag_sound, sound_take)

func open_bag() -> void:
	game_functions.play_audio(bag_sound, sound_open)
	is_open = true
	change_anim()

func close_bag() -> void:
	is_open = false
	if bag.animation.contains("opened"):
		game_functions.play_audio(bag_sound, sound_close)
	change_anim()
