extends Node


func switch_scene(_old_scene: Node, _new_scene: Node) -> void:
	# might want _new_scene to be a PackedScene
	_old_scene.queue_free()
	add_child(_new_scene)
