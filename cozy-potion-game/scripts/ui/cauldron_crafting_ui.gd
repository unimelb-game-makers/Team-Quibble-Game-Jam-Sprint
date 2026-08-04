extends CanvasLayer

@export var label_money_counter: Label
@export var container_recipe_list: VBoxContainer

var player_money: int = 0 :
    get:
        return player_money
    set(_value):
        player_money = _value
        label_money_counter.text = "$%010d" % player_money


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass

