extends Node2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

var player_affix: String = ""

func speedUp() -> void:
	animation.play("speed" + player_affix)

func _ready() -> void:
	animation.play("default" + player_affix)

func setPlayerOne() -> void:
	player_affix = "_p1"
	#animation.play("default_p1")

func setPlayerTwo() -> void:
	player_affix = "_p2"
	#animation.play("default_p2")

func _on_animated_sprite_2d_animation_finished() -> void:
	animation.play("default" + player_affix)
