extends Slot
class_name IngredientSlot

@onready var bag : AnimatedSprite2D = $Bag
@onready var bag_outline : AnimatedSprite2D = $Outline

@onready var shader : Shader = preload("res://resources/inventory/ingredient_slot.gdshader")

const colors : Array[float] = [0.0, 0.05, 0.29, 0.55, 0.68, 0.85]
@onready var own_color : Color

enum State {EMPTY, ONE, FULL}
var state : State = State.EMPTY

func change_anim(is_open : bool):
	var appended : String = ""
	if state == State.EMPTY:
		appended = "_empty"
	elif state == State.ONE:
		appended = "_one"
	var anim = "opened" + appended if is_open else "closed" + appended
	bag.animation = anim
	bag_outline.animation = anim

func _ready() -> void:
	super()
	change_anim(false)
	bag.material = ShaderMaterial.new()
	bag.material.shader = shader
	bag.material.set_shader_parameter("target_color", Color.from_hsv(colors[get_index()], 1.0, 0.74, 1.0))

func set_slot_data(slot_data: SlotData):
	super(slot_data)

	if !slot_data or slot_data.quantity <= 0:
		state = State.EMPTY
	elif slot_data.quantity <= 1:
		state = State.ONE
	else:
		state = State.FULL
	change_anim(false)

# Make tooltip visible when hovering, change to "opened bag"
func _on_mouse_entered() -> void:
	slot_hovered.emit(index, parent_inventory)
	change_anim(true)

# Make tooltip invisible when not hovering anymore, change to "closed bag"
func _on_mouse_exited() -> void:
	slot_hover_left.emit()
	change_anim(false)
