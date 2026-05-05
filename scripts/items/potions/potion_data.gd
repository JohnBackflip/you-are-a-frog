extends ItemData
class_name PotionData

@export var recipe: Array[IngredientData]

var recipe_unlocked: bool = false #This unlocks recipe and potion image
var effect_discovered: bool = false #This unlocks the actual potion name, set this to true after customer feedback
var analysed: bool = false #This unlocks description, set this to true after guild analysis
