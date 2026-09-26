extends Control

@onready var card_symbol: TextureRect = $Foreground/CardContent
@onready var animator: AnimationPlayer = $CardFlipper

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

func _process(delta: float) -> void:
	if animation_started and not animation_finished:
		if not animator.is_playing():
			animation_finished = true
			callback.flipNextCard()
