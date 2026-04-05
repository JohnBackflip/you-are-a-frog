extends Control

# Image for the color icon
const BLANK = preload("uid://cfwhanqe6jifd")

# Variables for the drawing function
@onready var center = size / 2
@onready var ring_radius = min(size.x, size.y) / 2

# Data: {property, quantity, color}
var ingredient_datas = []

# Keeps track of all properties e.g. ["HEALING", "POISONOUS"]
var property_types := []
# Keeps track of how many items in the mixer belong to a property e.g. {"HEALING": 0, "POISONOUS": 0}
var property_count := {} 
# Keeps track of the colours associated with each property
var property_colours := {}

# Create a color legend
var color_legend = GridContainer.new()


func _ready() -> void:
	print(center)
	# Initialises all properties
	for property_type in ItemData.Property:
		property_types.append(property_type)
		property_count[property_type] = 0
		property_colours[property_type] = Color(randf(), randf(), randf())
	print("Property types: %s" % str(property_types))
	print("Property colours: %s" % str(property_colours))
	hide()
	
	# Add color legend to the scene
	color_legend.columns = 2
	color_legend.position = global_position + Vector2(ring_radius, 0.0) + Vector2(100.0, 0)
	color_legend.top_level = true
	color_legend.scale = Vector2(0.8, 0.8)
	add_child(color_legend)
	
	
func reset_property_count() -> void:
	for property in property_count.keys():
		property_count[property] = 0


func update_ingredients(ingredients: Array[ItemData]) -> void:
	ingredient_datas.clear()
	reset_property_count()
	if ingredients.size() > 0:
		show()
	else:
		hide()
	
	# Count properties
	for item in ingredients:
		var index = item.property
		var property = property_types[index]
		if property_count[property] != null:
			property_count[property] += 1
	print("Property count: %s" % str(property_count))
	
	# Update ingredient list
	for property_type in property_types:
		var ingredient_data = {}
		ingredient_data["property"] = property_type
		ingredient_data["quantity"] = property_count[property_type]
		ingredient_data["color"] = property_colours[property_type]
		ingredient_datas.append(ingredient_data)
		
	# Redraw the chart
	update_color_legend()
	queue_redraw()


func update_color_legend() -> void:
	for child in color_legend.get_children():
		child.queue_free()
		
	for data in ingredient_datas:
		if data.quantity == 0:
			continue
		# Add color to legend
		var color_label = Label.new()
		color_label.text = data.property
		var color_icon = TextureProgressBar.new()
		color_icon.texture_progress = BLANK
		color_icon.tint_progress = data.color
		color_icon.value = 100
		color_legend.add_child(color_icon)
		color_legend.add_child(color_label)


func _draw() -> void:
	var ring_thickness = ring_radius / 2
	var current_angle = -90.0 # Start from the top
	var total_quantity: int = 0
	
	# This first loop calculates the total quantity of ingredients
	for data in ingredient_datas:
		total_quantity += data.quantity
	
	for data in ingredient_datas:
		var quantity = data.quantity
		var color = data.color
		var angle_delta = (float(quantity) / float(total_quantity)) * 360.0
		# Draw ring
		draw_arc(center, ring_radius, deg_to_rad(current_angle), deg_to_rad(current_angle + angle_delta), 128, color, ring_thickness, true)
		# Move on to the next section of the ring
		current_angle += angle_delta
		
