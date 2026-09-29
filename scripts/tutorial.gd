extends Control

class_name Tutorial

static func showTutorial(position: Vector2, text: String, parent: Node) -> Tutorial:
	var tutorial_scene: PackedScene = load("res://scenes/tutorial.tscn")
	var new_window: Tutorial = tutorial_scene.instantiate()
	new_window.position = position
	new_window.get_child(0).get_child(0).get_child(1).text = text
	parent.add_child(new_window)
	return new_window

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		get_tree().paused = false
		get_parent().remove_child(self)
		queue_free()
