extends Node2D

@export var number: int

var flash_warning: Node2D

func addWarning(warning: Node2D) -> void:
	flash_warning = warning
	add_child(flash_warning)
	flash_warning.position = Vector2(192.0, 150)

func removeWarning() -> void:
	if flash_warning:
		remove_child(flash_warning)
		flash_warning.queue_free()
		flash_warning = null
