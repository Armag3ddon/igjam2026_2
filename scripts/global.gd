extends Node

var player_count: int = 1

var player_one_bird: int
var player_two_bird: int

enum BIRDS {
	CROW,
	GOOSE,
	OWL,
	PARROT,
	PIGEON
}

func getBirdPackedScene(bird: int) -> PackedScene:
	if bird == BIRDS.CROW:
		return preload("res://scenes/birds/crow.tscn")
	return
