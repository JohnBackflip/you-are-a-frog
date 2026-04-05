extends Control

# Image for the colour icon
const BLANK = preload("uid://cfwhanqe6jifd")

# Variables for the drawing function
@onready var center = size / 2
@onready var ring_radius = min(size.x, size.y) / 2

# Data: {property, quantity, colour}
var ingredient_datas = []

# Keeps track of how many items in the mixer belong to a property e.g. {"HEALING": 0, "POISONOUS": 0}
var property_count := {} 
# Keeps track of the colours associated with each property
var property_colours := {}

# Create a colour legend
var colour_legend = GridContainer.new()


func _ready() -> void:
	hide()
	
	# Add colour legend to the scene
	colour_legend.columns = 2
	colour_legend.position = global_position + Vector2(ring_radius, 0.0) + Vector2(100.0, 0)
	colour_legend.top_level = true
	colour_legend.scale = Vector2(0.8, 0.8)
	add_child(colour_legend)
	
	
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
	for ingredient in ingredients:
		var property: IngredientProperty = ingredient.property
		var property_name = property.name
		var property_colour = property.colour
		if property_name in property_count:
			property_count[property_name] += 1
		else:
			property_count[property_name] = 1
		property_colours[property_name] = property_colour
	print("Property count: %s" % str(property_count))
	print("Property colours: %s" % str(property_colours))
	
	# Update ingredient list
	for property in property_count.keys():
		var ingredient_data = {}
		ingredient_data["property"] = property
		ingredient_data["quantity"] = property_count[property]
		ingredient_data["colour"] = property_colours[property]
		ingredient_datas.append(ingredient_data)
		
	# Redraw the chart
	update_colour_legend()
	queue_redraw()


func update_colour_legend() -> void:
	for child in colour_legend.get_children():
		child.queue_free()
		
	for data in ingredient_datas:
		if data.quantity == 0:
			continue
		# Add colour to legend
		var colour_label = Label.new()
		colour_label.text = data.property
		var colour_icon = TextureProgressBar.new()
		colour_icon.texture_progress = BLANK
		colour_icon.tint_progress = data.colour
		colour_icon.value = 100
		colour_legend.add_child(colour_icon)
		colour_legend.add_child(colour_label)


func _draw() -> void:
	var ring_thickness = ring_radius / 2
	var current_angle = -90.0 # Start from the top
	var total_quantity: int = 0
	
	# This first loop calculates the total quantity of ingredients
	for data in ingredient_datas:
		total_quantity += data.quantity
		# Warning: the total quantity calculation is a little weird at certain times but everything is working properly
	
	for data in ingredient_datas:
		var quantity = data.quantity
		var colour = data.colour
		var angle_delta = (float(quantity) / float(total_quantity)) * 360.0
		# Draw ring
		draw_arc(center, ring_radius, deg_to_rad(current_angle), deg_to_rad(current_angle + angle_delta), 128, colour, ring_thickness, true)
		# Move on to the next section of the ring
		current_angle += angle_delta
		
