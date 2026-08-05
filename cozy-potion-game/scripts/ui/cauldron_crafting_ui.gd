extends CanvasLayer

@export var potion_brewer: PotionBrewing
@export var label_money_counter: Label
@export var container_recipe_list: VBoxContainer
@export var reset_button: Button
@export var make_button: Button

var player_money: int = 0 :
	get:
		return player_money
	set(_value):
		player_money = _value
		label_money_counter.text = "$%s" % player_money

var current_potion: Array[PotionIngredient]
var ingredient_button: PackedScene = preload("uid://b6r6ktehhfb10")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_money = 0
	await potion_brewer.ready

	reset_button.pressed.connect(reset_potion)
	make_button.pressed.connect(create_potion)

	for entry in potion_brewer.potion_ingredient_index.values():
		var ingredient: Button = ingredient_button.instantiate()
		ingredient.text = entry.name
		ingredient.pressed.connect(add_ingredient.bind(ingredient, entry))
		container_recipe_list.add_child(ingredient)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func add_ingredient(_pressed_button: Button, _ingredient: PotionIngredient) -> void:
	if current_potion.has(_ingredient):
		return

	if current_potion.size() >= 2:
		for button: Button in container_recipe_list.get_children():
			button.disabled = true

	print("Adding %s to potion" % _ingredient.name)
	current_potion.append(_ingredient)
	_pressed_button.disabled = true


func create_potion() -> void:
	if current_potion.size() == 0:
		return

	var created_potion := potion_brewer.attempt_brewing(current_potion)
	print("made potion: ", created_potion.name)
	print("value: ", created_potion.value)
	player_money += created_potion.value

	reset_potion()

func reset_potion() -> void:
	current_potion.clear()

	for button: Button in container_recipe_list.get_children():
		button.disabled = false
