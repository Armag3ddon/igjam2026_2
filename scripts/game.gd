extends Node2D

@onready var racer_scene: PackedScene = preload("res://scenes/Racer.tscn")
@onready var danger_scene: PackedScene = preload("res://scenes/effects/LaneDanger.tscn")
@onready var card_drawer_scene: PackedScene = preload("res://scenes/cards.tscn")

var racers: Array[Racer] = []
var racers_strategy: Array[Array] = [[], [], [], [], []]

var racer_count: int = 5

@onready var manager: Node2D = $Racer_Manager
@onready var text_effect: Label = $CentralText
@onready var lanes: Array[Node2D] = [$Lane1, $Lane2, $Lane3, $Lane4, $Lane5]

enum game_states {
	GET,
	READY,
	TO,
	RACE,
	REPOSITION,
	DANGER,
	DRAW,
	DANGERFLY,
	UPDOWN
}
var game_state: int

var dangers: Array[bool] = [false, false, false, false, false]
var danger_time: float = 0.0
var danger_wait: float = 3.0

var reposition_time: float = 0.0
var reposition_wait: float = 2.0

var updown_time: float = 0.0
var updown_wait: float = 2.0

enum cards {
	TWOLEFT,
	LEFT,
	STAY,
	RIGHT,
	TWORIGHT
}

@onready var standard_cards: Array[Texture2D] = [
	load("res://assets/ui/card_2l.png"),
	load("res://assets/ui/card_1l.png"),
	load("res://assets/ui/card_0.png"),
	load("res://assets/ui/card_1r.png"),
	load("res://assets/ui/card_2r.png")
]

func _ready() -> void:
	for i: int in racer_count:
		var racer: Racer = racer_scene.instantiate()
		Global.is_player_human[i] = false
		if Global.player_one_bird == i:
			Global.is_player_human[i] = true
		if Global.player_count == 2 and Global.player_two_bird == i:
			Global.is_player_human[i] = true
		racer.setGraphics(Global.getBirdPackedScene(i))
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
	danger_time = 0.0
	var danger_count: int = roundi(randf() * 3.0) + 1
	for i: int in danger_count:
		var rnd: int = roundi(randf() * 4.0)
		while dangers[rnd]:
			rnd = roundi(randf() * 4.0)
		dangers[rnd] = true
	flashDanger()

func flashDanger() -> void:
	var i: int = 0
	for is_dangerous: bool in dangers:
		if is_dangerous:
			var warning: Node2D = danger_scene.instantiate()
			lanes[i].addWarning(warning)
		i += 1

func spawnDangers() -> void:
	var i: int = 0
	for is_dangerous: bool in dangers:
		lanes[i].removeWarning()
		if is_dangerous:
			lanes[i].spawnEnemy()
		i += 1
	reposition_time = 0.0
	game_state = game_states.DANGERFLY

func enemyDown() -> void:
	if game_state != game_states.DANGERFLY:
		return
	game_state = game_states.UPDOWN
	updown_time = 0.0
	for racer: Racer in racers:
		racer.processAdvance()

func drawCards() -> void:
	game_state = game_states.DRAW
	$BackgroundMusic.volume_db = -80.0
	$BackgroundMusic_Cards.volume_db = 0.0
	# Strategize for bots
	for i: int in 5:
		var current_lane: int = racers[i].grid_position.x
		racers_strategy[i] = []
		if not dangers[getWrappedLane(current_lane - 2)]:
			racers_strategy[i].append(cards.TWOLEFT)
		if not dangers[getWrappedLane(current_lane - 1)]:
			racers_strategy[i].append(cards.LEFT)
		if not dangers[getWrappedLane(current_lane)]:
			racers_strategy[i].append(cards.STAY)
		if not dangers[getWrappedLane(current_lane + 1)]:
			racers_strategy[i].append(cards.RIGHT)
		if not dangers[getWrappedLane(current_lane + 2)]:
			racers_strategy[i].append(cards.TWORIGHT)
	var card_drawer: Control = card_drawer_scene.instantiate()
	var standard_cards: Array[int] = [cards.TWOLEFT, cards.LEFT, cards.STAY, cards.RIGHT, cards.TWORIGHT]
	add_child(card_drawer)
	card_drawer.setupCards(standard_cards)
	card_drawer.timesToMove = roundi(randf() * 4.0) + 1
	card_drawer.init()

func getCardAsset(card_type: int) -> Texture2D:
	return standard_cards[card_type]

func processPlayerDraw(player: int, change: int):
	var current_position: Vector2 = racers[player].grid_position
	current_position.x += change
	current_position.x = getWrappedLane(current_position.x)
	racers[player].setNewPosition(current_position)

func getWrappedLane(lane: int) -> int:
	if lane > 4:
		return lane - 5
	if lane < 0:
		return lane + 5
	return lane

func drawDone():
	reposition_time = 0.0
	game_state = game_states.REPOSITION
	$BackgroundMusic.volume_db = 0.0
	$BackgroundMusic_Cards.volume_db = -80.0

func _process(delta: float) -> void:
	if game_state == game_states.DANGER:
		danger_time += delta
		if danger_time >= danger_wait:
			drawCards()
	if game_state == game_states.REPOSITION:
		reposition_time += delta
		if reposition_time >= reposition_wait:
			spawnDangers()
	if game_state == game_states.UPDOWN:
		updown_time += delta
		if updown_time >= updown_wait:
			drawDanger()
	if game_state == game_states.DRAW:
		debug_time += delta
		if debug_time >= debug_wait:
			debugRandomMove()

var debug_time: float = 0.0
var debug_wait: float = 1.0

func debugRandomMove() -> void:
	return
	for i: int in 5:
		processPlayerDraw(i, roundi(randf() * 4.0 - 2.0))
	drawDone()
	debug_time = 0.0
