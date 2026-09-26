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

func getBirdPortrait(bird: int) -> String:
	if bird == BIRDS.CROW:
		return "res://assets/portraits/crow_portrait.jpg"
	if bird == BIRDS.GOOSE:
		return "res://assets/portraits/goose_portrait.jpg"
	if bird == BIRDS.OWL:
		return "res://assets/portraits/owl_portrait.jpg"
	if bird == BIRDS.PARROT:
		return "res://assets/portraits/parrot_portrait.jpg"
	if bird == BIRDS.PIGEON:
		return "res://assets/portraits/pigeon_portrait.jpg"
	return ""
