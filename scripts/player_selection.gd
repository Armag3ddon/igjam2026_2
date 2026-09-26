extends Control

var player_one_selection: int
var player_one_done: bool = false
@onready var player_one_portrait: TextureRect = $PlayerSelectorContainer/FirstPlayerSelector/Portrait
@onready var player_one_name: Label = $PlayerSelectorContainer/FirstPlayerSelector/PanelContainer/Birdname
@onready var player_one_emitter: CPUParticles2D = $PlayerSelectorContainer/FirstPlayerSelector/FirstPlayerEmitter

var player_two_selection: int
var player_two_done: bool = false
@onready var player_two: VBoxContainer = $PlayerSelectorContainer/SecondPlayerSelector
@onready var player_two_portrait: TextureRect = $PlayerSelectorContainer/SecondPlayerSelector/Portrait
@onready var player_two_name: Label = $PlayerSelectorContainer/SecondPlayerSelector/PanelContainer/Birdname
@onready var player_two_emitter: CPUParticles2D = $PlayerSelectorContainer/SecondPlayerSelector/SecondPlayerEmitter

var wait_time: float = 1.0

func _ready() -> void:
	wait_time = 1.0
	player_one_selection = Global.BIRDS.values().pick_random()
	playerOneChanged()
	player_one_emitter.visible = false
	player_one_done = false
	if Global.player_count == 2:
		player_two.visible = true
		player_two_selection = Global.BIRDS.values().pick_random()
		playerTwoChanged()
		player_two_emitter.visible = false
		player_two_done = false
	else:
		player_two.visible = false

func playerOneChanged() -> void:
	var portrait: Texture2D = load(Global.getBirdPortrait(player_one_selection))
	var name: String = Global.getBirdNames(player_one_selection)
	player_one_portrait.texture = portrait
	player_one_name.text = name

func playerOneChange(change: int) -> void:
	player_one_selection += change
	if player_one_selection < 0:
		player_one_selection = Global.BIRDS.size()-1
	if player_one_selection >= Global.BIRDS.size():
		player_one_selection = 0
	playerOneChanged()

func playerOneAccept() -> void:
	if Global.player_count == 2:
		if player_one_selection == player_two_selection:
			pass
	player_one_emitter.visible = true
	player_one_done = true

func _on_player_one_left_pressed() -> void:
	playerOneChange(-1)

func _on_player_one_right_pressed() -> void:
	playerOneChange(1)

func playerTwoChanged() -> void:
	var portrait: Texture2D = load(Global.getBirdPortrait(player_two_selection))
	var name: String = Global.getBirdNames(player_two_selection)
	player_two_portrait.texture = portrait
	player_two_name.text = name

func playerTwoChange(change: int) -> void:
	player_two_selection += change
	if player_two_selection < 0:
		player_two_selection = Global.BIRDS.size()-1
	if player_two_selection >= Global.BIRDS.size():
		player_two_selection = 0
	playerTwoChanged()

func playerTwoAccept() -> void:
	if player_one_selection == player_two_selection:
		pass
	player_two_emitter.visible = true
	player_two_done = true

func _on_player_two_left_pressed() -> void:
	playerTwoChange(-1)

func _on_player_two_right_pressed() -> void:
	playerTwoChange(1)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("PlayerOne_Left"):
		playerOneChange(-1)
	if event.is_action_pressed("PlayerOne_Right"):
		playerOneChange(1)
	if event.is_action_pressed("PlayerTwo_Left"):
		playerTwoChange(-1)
	if event.is_action_pressed("PlayerTwo_Right"):
		playerTwoChange(1)
	if event.is_action_pressed("PlayerOne_Accept"):
		playerOneAccept()
	if event.is_action_pressed("PlayerTwo_Accept"):
		playerTwoAccept()

func _process(delta: float) -> void:
	if player_one_done:
		if Global.player_count == 2:
			if player_two_done:
				doWait(delta)
		else:
			doWait(delta)

func doWait(delta: float) -> void:
	wait_time -= delta
	if wait_time < 0.0:
		Global.player_one_bird = player_one_selection
		Global.player_two_bird = player_two_selection
		get_tree().change_scene_to_file("res://scenes/game.tscn")
