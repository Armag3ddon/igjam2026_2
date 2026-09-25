extends Node2D

@onready var racer_scene: PackedScene = preload("res://scenes/Racer.tscn")

var racers: Array[Racer] = []

var racer_count: int = 5

@onready var manager: Node2D = $Racer_Manager

func _ready() -> void:
	for i in racer_count:
		var racer: Racer = racer_scene.instantiate()
		racers.append(racer)
		racers[i].setNewPosition(Vector2(i, 10))
		manager.add_child.call_deferred(racer)
