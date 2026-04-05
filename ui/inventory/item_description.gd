extends TabContainer

@onready var description : RichTextLabel = $Description/RichTextLabel
@onready var known_recipes : RichTextLabel = $"Known Recipes"/RichTextLabel

func set_info(slot_data : SlotData) :
	visible = slot_data != null
	var item_data = slot_data.item_data
	description.text =	"[b]Name: [/b]" + item_data.name + \
						"\n[b]Description: [/b]" + item_data.description + \
						"\n[b]Property: [/b]" + item_data.property.name
