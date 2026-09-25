extends Node2D

@onready var racer_scene: PackedScene = preload("res://scenes/Racer.tscn")

var racers: Array[Racer] = []

var racer_count: int = 5

@onready var manager: Node2D = $Racer_Manager
@onready var text_effect: Label = $CentralText

enum game_states {
	GET,
	READY,
	TO,
	RACE,
	REPOSITION,
	DANGER,
	DRAW
}
var game_state: int

var dangers: Array[bool] = [false, false, false, false, false]
var danger_time: float = 0.0
var danger_wait: float = 3.0

func _ready() -> void:
	for i: int in racer_count:
		var racer: Racer = racer_scene.instantiate()
		racers.append(racer)
		racers[i].setNewPosition(Vector2(i, 10))
		manager.add_child.call_deferred(racer)
	game_state = game_states.GET
	text_effect.action("GET", 1.5)

func _on_central_text_text_finished() -> void:
	if game_state == game_states.RACE:
		drawDanger()
	if game_state == game_states.TO:
		text_effect.action("RACE", 1.5)
		game_state = game_states.RACE
	if game_state == game_states.READY:
		text_effect.action("TO", 1.0)
		game_state = game_states.TO
	if game_state == game_states.GET:
		text_effect.action("READY", 1.5)
		game_state = game_states.READY

func drawDanger() -> void:
	game_state = game_states.DANGER
	dangers = [false, false, false, false, false]
	var danger_count: int = roundi(randf() * 3.0) + 1
	for i: int in danger_count:
		var rnd: int = roundi(randf() * 4.0)
		while dangers[rnd]:
			rnd = roundi(randf() * 4.0)
		dangers[rnd] = true

func _process(delta: float) -> void:
	if game_state == game_states.DANGER:
		pass
