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

func read_json_data() -> void:
	var json_string: String = FileAccess.open(json_path, FileAccess.READ).get_as_text()
	var json_data: JSON = JSON.new()

	assert(json_data.parse(json_string) == OK, 
			"Variable json_data was null. %s" % [json_data.get_error_message()])

	var potion_data = json_data.data["potions"]

	# this should be changed for a more efficent option
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
		
