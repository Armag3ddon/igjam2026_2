extends Control

class_name Tutorial

static func showTutorial(position: Vector2, text: String, parent: Node) -> Tutorial:
	var new_window: Tutorial = Tutorial.new()
	new_window.position = position
	new_window.get_child(0).get_child(0).get_child(1).text = text
	parent.add_child(new_window)
	get_tree.paused = true
	return new_window

func _input(event: InputEvent) -> void:
	get_parent().remove_child(self)
	queue_free()
	get_tree().paused = false
