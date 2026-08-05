class_name PotionBrewing
extends Node

var potion_ingredient_index: Dictionary[String, PotionIngredient]
var json_path: String = "res://scripts/potion_crafting/potion_list.json"
var placeholder: Texture = preload("res://icon.svg")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	read_json_data()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func attempt_brewing(_potion_recipe: Array[PotionIngredient]) -> Potion:
	# Unless something else broke, this method shouldn't get a recipe bigger than 3 ingredients
	assert(_potion_recipe.size() <= 3 and _potion_recipe.size() > 0,
			"Attempted to brew a potion with more than 3 ingredients")

	# This could be moved to the potion.gd constructor
	var index := 1
	var potion := Potion.new()

	# Things kept changing the resources
	var effect_score := _potion_recipe[0].effects.duplicate()
	var type_score := _potion_recipe[0].type.duplicate()
	
	var effect_sum: float = effect_score.values().reduce(PotionIngredient.sum, 0)

	while true:
		if _potion_recipe.size() <= index:
			break

		for effect_name in _potion_recipe[index].effects.keys():
			effect_score[effect_name] *= 1 + _potion_recipe[index].effects[effect_name] / effect_sum

		for type_name in _potion_recipe[index].type.keys():
			type_score[type_name] += _potion_recipe[index].type[type_name]
		
		index += 1

	var potion_afinity: String = Potion.get_max(effect_score)
	var potion_type: String = Potion.get_max(type_score)

	potion.name = "Potion of %s %s" % [potion_type, potion_afinity]
	potion.value = Potion.get_value(effect_score) + type_score[potion_type]

	return potion


func read_json_data() -> void:
	var json_string: String = FileAccess.open(json_path, FileAccess.READ).get_as_text()
	var json_data: JSON = JSON.new()

	assert(json_data.parse(json_string) == OK, 
			"Variable json_data was null. %s" % [json_data.get_error_message()])

	var potion_data = json_data.data["potions"]

	# this should be changed for a more efficent option at some point
	for entry in potion_data:
		var temp_potion: PotionIngredient = PotionIngredient.new()
		temp_potion.name = entry["name"]
		temp_potion.sprite = placeholder

		temp_potion.healing = entry["healing"]
		temp_potion.energy = entry["energy"]
		temp_potion.cure_disease = entry["cure_disease"]
		temp_potion.poison = entry["poison"]

		temp_potion.instant = entry["instant"]
		temp_potion.overtime = entry["overtime"]

		potion_ingredient_index[temp_potion.name] = temp_potion.duplicate()
		
