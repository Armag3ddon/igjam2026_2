extends Node2D

signal enemy_down

var speed: float = 450.0

func _process(delta: float) -> void:
	position.y += speed * delta
	if position.y >= 1090.0:
		queue_free()
		enemy_down.emit()

func _on_area_2d_area_entered(area: Area2D) -> void:
	var racer: Node2D = area.get_parent().get_parent()
	racer.registerHit()
