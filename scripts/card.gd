extends Control

@onready var card_symbol: TextureRect = $Foreground/CardContent
@onready var animator: AnimationPlayer = $CardFlipper

@export var selection_portrait: TextureRect

var card_type: int

var animation_started: bool = false
var animation_finished: bool = false

var callback: Control

func setCardType(type: int, symbol: Texture2D) -> void:
	card_symbol.texture = symbol
	card_type = type

func flip(card_drawer: Control) -> void:
	animator.play("flip")
	animation_started = true
	callback = card_drawer

func unflip() -> void:
	animator.play("unflip")

func picked(player: int) -> void:
	var affix: String = ""
	if player == Global.player_one_bird:
		affix = "_p1"
	if player == Global.player_two_bird and Global.player_count > 1:
		affix = "_p2"
	var picked_texture: Texture2D = load("res://assets/ui/card" + affix + ".png")
	var picked_back: Texture2D = load("res://assets/ui/card_back" + affix + ".png")
	$Foreground.texture = picked_texture
	$Background.texture = picked_back

func _process(delta: float) -> void:
	if animation_started and not animation_finished:
		if not animator.is_playing():
			animation_finished = true
			callback.flipNextCard()
