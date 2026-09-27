extends Node2D

var existing: float = 0.0
@onready var feather_effect = $Feathers

func _ready() -> void:
	feather_effect.restart()

func _process(delta: float) -> void:
	existing += delta
	if existing > 1.0:
		get_parent().remove_child(self)
		queue_free()
