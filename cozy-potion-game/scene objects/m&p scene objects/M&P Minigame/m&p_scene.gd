#controller for mortar and pestle scene
extends Control

@export var win_label_placeholder: RichTextLabel
var win_check_timer: float
const win_check_interval: float = 0.1

#checks all the objects with tag ingredient ball to see if any have not reached their split limit
#runs every 0.1 seconds or so
func check_if_won():
	for object in get_tree().get_nodes_in_group("IngredientBall"):
		print_debug(object)
		if object is IngredientBall:
			if object.split_count < object.split_limit:
				return
	win_minigame()

func _process(delta: float) -> void:
	win_check_timer += delta
	if win_check_timer > win_check_interval:
		check_if_won()
		win_check_timer = 0
		
func win_minigame():
	win_label_placeholder.show()
