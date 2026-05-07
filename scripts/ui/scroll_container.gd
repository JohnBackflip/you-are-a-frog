extends ScrollContainer

@onready var arrow: TextureRect = $"../ScrollArrow"


func _ready():
	var v_bar = get_v_scroll_bar()
	v_bar.value_changed.connect(_on_scroll_changed)
	v_bar.changed.connect(_on_scroll_changed.bind(0)) # Re-check when text size changes

func _on_scroll_changed(_value):
	var scrollbar = get_v_scroll_bar()
	# 1. Check if the content is even long enough to scroll
	# We use a small buffer (like 2 pixels) to avoid float rounding errors
	var can_scroll = scrollbar.max_value > scrollbar.page
	
	# 2. Check if we are at the bottom
	var is_at_bottom = scrollbar.value >= (scrollbar.max_value - scrollbar.page)
	
	# The arrow should only show if we CAN scroll AND we aren't at the bottom yet
	if can_scroll and not is_at_bottom:
		arrow.show()
	else:
		arrow.hide()
